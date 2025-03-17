import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/model/ChatModel.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../utils/AppColors.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getMessage();
  Future<void>sendMessage(Map<String, dynamic> message);
  Stream<List<ChatModel>> getChat();


}

class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<MessageModel>> getMessage() {
    User user = _auth.currentUser!;
    return _firestore.collection('Chatrooms')
        .where('participants', arrayContains: user.uid)
        .snapshots()
        .asyncExpand((querySnapshot) {
      return Stream.fromFutures(querySnapshot.docs.map((doc) {
        return doc.reference.collection('Messages')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .asyncMap((messageSnapshot) async {
          return Future.wait(messageSnapshot.docs.map((messageDoc) async {
            return await MessageModel.fromDocumentSnapshotWithUserData(messageDoc);
          }).toList());
        }).first;
      }));
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

      if (message['image'] != null) {

        Uint8List MessaggeBytes = await File(message['image']!).readAsBytes();

        fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference storageRef = _storage.ref().child(
            'ChatMessage/$senderID/$fileName.jpg');
        UploadTask uploadTask = storageRef.putData(MessaggeBytes);
        TaskSnapshot taskSnapshot = await uploadTask;
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
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
        DocumentReference newChatroomDoc = await _firestore.collection(
            'Chatrooms').add({
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

      ToastComponent().showMessage(
          AppColors.orange, 'Message sent successfully');
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  @override
  Stream<List<ChatModel>> getChat() {
    User user = _auth.currentUser!;
    String userid = user.uid;

    return _firestore.collection('Chatrooms')
        .where('participants', arrayContains: userid)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<ChatModel> chatList = [];
      for (var doc in querySnapshot.docs) {
        var chatData = doc.data();
        var senderID = chatData['senderID'];
        var receiverID = chatData['receiverID'];

        var senderDoc = await _firestore.collection('Users').doc(senderID).get();
        var receiverDoc = await _firestore.collection('Users').doc(receiverID).get();

        var senderName = senderDoc['Name'];
        var receiverName = receiverDoc['Name'];
        var profilePath = userid == receiverID ? senderDoc['ProfileUrl'] : receiverDoc['ProfileUrl'];
        var displayName = userid == receiverID ? senderName : receiverName;

        chatList.add(ChatModel(
          id: doc.id,
         name: displayName,
          profilepath: profilePath,
          lastMessage: chatData['lastMessage'],
          senderID: senderID,
          receiverID: receiverID
        ));
      }
      return chatList;
    });
  }


}

