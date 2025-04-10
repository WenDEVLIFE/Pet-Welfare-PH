import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

abstract class ReportRepository {
  Future <void> submitReport(String reason, String postId, Function clearCallback);

}

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<void> submitReport(String reason, String postId, Function clearCallback) async {

    User ? user = firebaseAuth.currentUser;
    String userId = user?.uid ?? '';

    // Create a report document in Firestore
    QuerySnapshot reportRef = await firebaseFirestore.collection('ReportCollection')
        .where('PostID', isEqualTo: postId)
        .where('UserId', isEqualTo: userId)
       .get();

    if (reportRef.docs.isEmpty) {
      await firebaseFirestore.collection('ReportCollection').add({
        'PostID': postId,
        'UserId': userId,
        'Reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field after submission
      clearCallback();

      // Show a success message
      print('Report submitted successfully.');
      ToastComponent().showMessage(Colors.green, 'Report submitted successfully.');
    } else {
      // Handle the case where the user has already reported this post
      print('You have already reported this post.');
      ToastComponent().showMessage(Colors.red, 'You have already reported this post.');
    }

  }

}