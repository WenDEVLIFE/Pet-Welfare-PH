import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/model/ChatModel.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../utils/AppColors.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getMessage(String receiverId);
  Future<void>sendMessage(Map<String, dynamic> message);
  Stream<List<ChatModel>> getChat();


}

class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<MessageModel>> getMessage(String receiverId) {
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
      List<MessageModel> messages = [];

      for (var doc in querySnapshot.docs) {
        // Check if this chatroom involves the receiver we want
        List<dynamic> participants = doc['participants'];
        if (participants.contains(receiverId)) {
          // Found the right chatroom - get its messages
          QuerySnapshot messagesSnapshot = await doc.reference
              .collection('Messages')
              .orderBy('timestamp', descending: false)
              .get();

          for (var messageDoc in messagesSnapshot.docs) {
            MessageModel message = await MessageModel.fromDocumentSnapshotWithUserData(messageDoc);
            messages.add(message);
          }

          // We found the chatroom we want, no need to check others
          break;
        }
      }

      return messages;
    });
    }
  }

  // Send the message to the receiver or sender
  @override
  Future<void> sendMessage(Map<String, dynamic> message) async {
    User user = _auth.currentUser!;
    String senderID = user.uid;

    try {
      String? downloadUrl;
      String? fileName;

      if (message['image'] != null) {
        File imageFile = File(message['image']!);
        if (await imageFile.exists()) {
          Uint8List messageBytes = await imageFile.readAsBytes();

          fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef = _storage.ref().child('ChatMessage/$senderID/$fileName.jpg');
          UploadTask uploadTask = storageRef.putData(messageBytes);
          TaskSnapshot taskSnapshot = await uploadTask;
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
        }
      }

      // Check if a chatroom document already exists between the sender and receiver
      QuerySnapshot querySnapshot = await _firestore.collection('Chatrooms')
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
        // Insert the message into the existing chatroom's nested collection
        await _firestore.collection('Chatrooms').doc(chatroomData.id)
            .collection('Messages').add({
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'Message': message['content'],
          if (downloadUrl != null) 'ImageName': '$fileName.jpg',
          if (downloadUrl != null) 'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp()
        });
      } else {
        // Create a new chatroom document
        DocumentReference newChatroomDoc = await _firestore.collection('Chatrooms').add({
          'participants': [senderID, message['receiverID']],
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'lastMessage': message['content'],
          if (downloadUrl != null) 'ImageName': '$fileName.jpg',
          if (downloadUrl != null) 'imageUrl': downloadUrl,
          'createdAt': FieldValue.serverTimestamp()
        });
        // Insert the message into the new chatroom's nested collection
        await newChatroomDoc.collection('Messages').add({
          'senderID': senderID,
          'receiverID': message['receiverID'],
          'Message': message['content'],
          if (downloadUrl != null) 'ImageName': '$fileName.jpg',
          if (downloadUrl != null) 'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp()
        });
      }

      ToastComponent().showMessage(AppColors.orange, 'Message sent successfully');
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
      
    return _firestore.collection('Chatrooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<ChatModel> chatList = [];
      for (var doc in querySnapshot.docs) {
        var chatData = doc.data();
        var senderID = chatData['senderID'];
        var receiverID = chatData['receiverID'];

        // Determine the other user's ID (the one who isn't the current user)
        String otherUserId = (currentUserId == senderID) ? receiverID : senderID;

        // Get the other user's document
        var otherUserDoc = await _firestore.collection('Users').doc(otherUserId).get();

        // Get the other user's name and profile picture
        var otherUserName = otherUserDoc['Name'] ?? 'Unknown';
        var otherUserProfile = otherUserDoc['ProfileUrl'] ?? '';

        chatList.add(ChatModel(
            id: doc.id,
            name: otherUserName,
            profilepath: otherUserProfile,
            lastMessage: chatData['lastMessage'] ?? '',
            senderID: senderID,
            receiverID: receiverID
        ));
      }
      return chatList;
    });
    }
  }


}

