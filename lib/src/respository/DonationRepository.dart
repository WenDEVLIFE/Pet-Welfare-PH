import 'dart:io';
import 'dart:typed_data'; // Correct import for Uint8List

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

abstract class DonationRepository {
  Future <void> submitDonation(Map<String, dynamic> donation);
}

class DonationRepositoryImpl implements DonationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final SessionManager _sessionManager = SessionManager();

  // Add the donation to the database
  @override
  Future<void> submitDonation(Map<String, dynamic> donation) async {
    User user = _auth.currentUser!;
    String id = user.uid;
    String postID = donation['postId'];
    String amount = donation['amount'];
    String date = donation['date'];
    String time = donation['time'];

    final userdata = await _sessionManager.getUserInfo();
    String name = userdata?['name'];

    File imageFile = File(donation['transactionPath']!);
    if (await imageFile.exists()) {
      Uint8List messageBytes = await imageFile.readAsBytes();

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('PostFolder/$postID/$fileName.jpg');
      UploadTask uploadTask = storageRef.putData(messageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      try {
        DocumentSnapshot documentSnapshot = await _firestore.collection('PostCollection')
            .doc(postID)
            .get();

        if (documentSnapshot.exists) {
          String postOwnerID = documentSnapshot['PostOwnerID'];
          await _firestore.collection("PostCollection").doc(postID).collection("DonationCollection").add({
            'Amount': amount,
            'Date': date,
            'Time': time,
            'TransactionFile': '$fileName.jpg',
            'TransactionPath': downloadUrl,
            'UserID': id,
          });

          DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
          await notificationRef.set({
            'notificationID': notificationRef.id,
            'userID': postOwnerID,
            'content': 'You have received a donation from $name',
            'timestamp': FieldValue.serverTimestamp(),
            'category': 'Donation',
            'isRead': false,
          });

          ToastComponent().showMessage(Colors.green, 'Donation submitted successfully');
        } else{
          ToastComponent().showMessage(Colors.red, 'Donation failed');
        }


      } catch (e) {
        print(e);
      }
    }
  }
}