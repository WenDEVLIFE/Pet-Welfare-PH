import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/model/ChatModel.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../utils/AppColors.dart';
import 'package:rxdart/rxdart.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getMessage(String receiverId);

  Future<void> sendMessage(Map<String, dynamic> message);

  Stream<List<ChatModel>> getChat();
}

class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<MessageModel>> getMessage(String receiverId) {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) return Stream.value([]);

      final String currentUserId = user.uid;

      // Find the chatroom first
      return _firestore
          .collection('Chatrooms')
          .where('participants', arrayContains: currentUserId)
          .snapshots()
          .switchMap((querySnapshot) {
        DocumentSnapshot? targetChatroom;

        for (var doc in querySnapshot.docs) {
          final participants = (doc['participants'] as List?) ?? const [];
          if (participants.contains(receiverId)) {
            targetChatroom = doc;
            break;
          }
        }

        if (targetChatroom == null) return Stream.value([]);

        // ✅ Persistent cache for this subscription
        final List<MessageModel> cache = [];

        final messagesRef = targetChatroom!.reference
            .collection('Messages')
            .orderBy('timestamp', descending: false);

        return messagesRef.snapshots().map((snap) {
          for (final change in snap.docChanges) {
            final id = change.doc.id;

            if (change.type == DocumentChangeType.added) {
              final msg =
                  MessageModel.fromDocumentSnapshotWithUserDataSync(change.doc);
              final insertAt =
                  (change.newIndex >= 0 && change.newIndex <= cache.length)
                      ? change.newIndex
                      : cache.length;
              cache.insert(insertAt, msg);
            } else if (change.type == DocumentChangeType.modified) {
              // Replace existing & keep order per newIndex
              final existingIdx = cache.indexWhere((m) => m.id == id);
              final msg =
                  MessageModel.fromDocumentSnapshotWithUserDataSync(change.doc);
              if (existingIdx != -1) {
                cache.removeAt(existingIdx);
              }
              final insertAt =
                  (change.newIndex >= 0 && change.newIndex <= cache.length)
                      ? change.newIndex
                      : cache.length;
              cache.insert(insertAt, msg);
            } else if (change.type == DocumentChangeType.removed) {
              cache.removeWhere((m) => m.id == id);
            }
          }

          // Return an immutable view
          return List<MessageModel>.unmodifiable(cache);
        });
      });
    });
  }

  // Send the message to the receiver or sender
  @override
  Future<void> sendMessage(Map<String, dynamic> message) async {
    User user = _auth.currentUser!;
    String senderID = user.uid;

    try {
      String? downloadUrl;
      String? fileName;

      // 🖼 Upload image if exists
      if (message['image'] != null) {
        File imageFile = File(message['image']!);
        if (await imageFile.exists()) {
          Uint8List messageBytes = await imageFile.readAsBytes();

          fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef =
              _storage.ref().child('ChatMessage/$senderID/$fileName.jpg');
          UploadTask uploadTask = storageRef.putData(messageBytes);
          TaskSnapshot taskSnapshot = await uploadTask;
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
        }
      }

      // 🔍 Get sender & receiver user data
      DocumentSnapshot senderDoc =
          await _firestore.collection('Users').doc(senderID).get();
      DocumentSnapshot receiverDoc =
          await _firestore.collection('Users').doc(message['receiverID']).get();

      String senderName = senderDoc['Name'] ?? '';
      String senderProfileImage = senderDoc['ProfileUrl'] ?? '';
      String receiverName = receiverDoc['Name'] ?? '';
      String receiverProfileImage = receiverDoc['ProfileUrl'] ?? '';

      // 🔍 Check if chatroom already exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('Chatrooms')
          .where('participants', arrayContains: senderID)
          .orderBy('createdAt', descending: true)
          .get();

      DocumentSnapshot? chatroomData;
      for (var doc in querySnapshot.docs) {
        if ((doc['participants'] as List).contains(message['receiverID'])) {
          chatroomData = doc;
          break;
        }
      }

      if (chatroomData != null) {
        // ✅ Existing chatroom
        DocumentReference chatroomRef =
            _firestore.collection('Chatrooms').doc(chatroomData.id);

        // Create new message
        DocumentReference msgRef = chatroomRef.collection('Messages').doc();

        await msgRef.set({
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'senderName': senderName,
          'senderProfileImage': senderProfileImage,
          'receiverName': receiverName,
          'receiverProfileImage': receiverProfileImage,
          'Message': message['content'],
          if (downloadUrl != null) 'ImageName': '$fileName.jpg',
          if (downloadUrl != null) 'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'sending',
        });

        // Update status → sent
        await msgRef.update({'status': 'sent'});

        // ✅ Update lastMessage in Chatroom
        await chatroomRef.update({
          'lastMessage':
              message['content'].isNotEmpty ? message['content'] : '[Image]',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageSender': senderID,
          'lastMessageSenderName': senderName,
          'lastMessageSenderProfile': senderProfileImage,
        });
      } else {
        // ✅ New chatroom
        DocumentReference newChatroomDoc =
            await _firestore.collection('Chatrooms').add({
          'participants': [senderID, message['receiverID']],
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'senderName': senderName,
          'senderProfileImage': senderProfileImage,
          'receiverName': receiverName,
          'receiverProfileImage': receiverProfileImage,
          'lastMessage':
              message['content'].isNotEmpty ? message['content'] : '[Image]',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageSender': senderID,
          'lastMessageSenderName': senderName,
          'lastMessageSenderProfile': senderProfileImage,
          'createdAt': FieldValue.serverTimestamp()
        });

        DocumentReference msgRef = newChatroomDoc.collection('Messages').doc();

        await msgRef.set({
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'senderName': senderName,
          'senderProfileImage': senderProfileImage,
          'receiverName': receiverName,
          'receiverProfileImage': receiverProfileImage,
          'Message': message['content'],
          if (downloadUrl != null) 'ImageName': '$fileName.jpg',
          if (downloadUrl != null) 'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'sending',
        });

        await msgRef.update({'status': 'sent'});
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // fetch the chatrooms between the sender and receiver
  @override
  Stream<List<ChatModel>> getChat() {
    return _auth.authStateChanges().switchMap((user) {
      // If the user is logged out, return an empty list of messages
      if (user == null) {
        return Stream.value([]);
      }

      // If a user is logged in, create the Firestore query with their UID
      final String currentUserId = user.uid;

      return _firestore
          .collection('Chatrooms')
          .where('participants', arrayContains: currentUserId)
          .snapshots()
          .asyncMap((querySnapshot) async {
        List<ChatModel> chatList = [];
        for (var doc in querySnapshot.docs) {
          var chatData = doc.data();
          var senderID = chatData['senderID'];
          var receiverID = chatData['receiverID'];

          // Determine the other user's ID (the one who isn't the current user)
          String otherUserId =
              (currentUserId == senderID) ? receiverID : senderID;

          // Get the other user's document
          var otherUserDoc =
              await _firestore.collection('Users').doc(otherUserId).get();

          // Get the other user's name and profile picture
          var otherUserName = otherUserDoc['Name'] ?? 'Unknown';
          var otherUserProfile = otherUserDoc['ProfileUrl'] ?? '';

          chatList.add(ChatModel(
              id: doc.id,
              name: otherUserName,
              profilepath: otherUserProfile,
              lastMessage: chatData['lastMessage'] ?? '',
              senderID: senderID,
              receiverID: receiverID));
        }
        return chatList;
      });
    });
  }
}
