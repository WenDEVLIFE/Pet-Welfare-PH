import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

abstract class ReportRepository {
  Future <void> submitReport(Map<String, dynamic> reportData, Function clearCallback);

}

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<void> submitReport(Map<String, dynamic> reportData, Function clearCallback) async {

    User ? user = firebaseAuth.currentUser;
    String userId = user?.uid ?? '';

    String postId = reportData['PostID'];
    String reason = reportData['Reason'];
    String filePath = reportData['FilePath'];

    // Create a report document in Firestore
    QuerySnapshot reportRef = await firebaseFirestore.collection('ReportCollection')
        .where('PostID', isEqualTo: postId)
        .where('UserId', isEqualTo: userId)
       .get();

    if (reportRef.docs.isEmpty) {

      // If a file path is provided, upload the file to Firebase Storage
      if (filePath.isNotEmpty) {
        // Upload the file to Firebase Storage
        Reference storageRef = FirebaseStorage.instance.ref('reports/$postId');
        await storageRef.putFile(File(filePath));

        // Get the download URL of the uploaded file
        String downloadUrl = await storageRef.getDownloadURL();

        // Add the file URL to the Firestore document
        await firebaseFirestore.collection('ReportCollection').add({
          'PostID': postId,
          'UserId': userId,
          'Reason': reason,
          'FilePath': downloadUrl, // Store the file URL here
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

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