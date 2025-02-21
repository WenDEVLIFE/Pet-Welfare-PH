import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

abstract class UpdateProfileRepository {
  Future<void> updateProfile(Map<String, String> userData, bool isImage, BuildContext context);

  void updateProfile1(Map<String, String> userData, bool isImage, BuildContext context);
}

class UpdateProfileImpl extends UpdateProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> updateProfile(Map<String, String> userData, bool isImage, BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Updating profile...');
    final user = _auth.currentUser;

    if (user == null) {
      ToastComponent().showMessage(Colors.red, 'User not logged in.');
      pd.close();
      return;
    }

    try {
      String id = user.uid;

      QuerySnapshot userDoc = await _firestore.collection('Users').where('Uid', isEqualTo: id).get();
      if (userDoc.docs.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'User document not found.');
        pd.close();
        return;
      }

      var idType = userData['idType'];
      var idfrontPath = userData['idfrontpath'];
      var idbackPath = userData['idbackpath'];

      if (idfrontPath == null || idbackPath == null) {
        ToastComponent().showMessage(Colors.red, 'ID paths are invalid.');
        pd.close();
        return;
      }

      Uint8List bytesIdFront = await File(idfrontPath).readAsBytes();
      Uint8List bytesIdBack = await File(idbackPath).readAsBytes();
      Reference idFrontRef = FirebaseStorage.instance.ref().child('ID/$id-front.jpg');
      Reference idBackRef = FirebaseStorage.instance.ref().child('ID/$id-back.jpg');

      // Delete existing files if they exist
      try {
        await idFrontRef.delete();
      } catch (e) {
        print('No existing front ID to delete.');
      }
      try {
        await idBackRef.delete();
      } catch (e) {
        print('No existing back ID to delete.');
      }

      // Upload new files
      TaskSnapshot idFrontSnap = await idFrontRef.putData(bytesIdFront);
      TaskSnapshot idBackSnap = await idBackRef.putData(bytesIdBack);

      String idFrontUrl = await idFrontSnap.ref.getDownloadURL();
      String idBackUrl = await idBackSnap.ref.getDownloadURL();

      // Update Firestore with new URLs
      await _firestore.collection('Users').doc(id).update({
        'IDType': idType,
        'IDFrontImage': '$id-front.jpg',
        'IDBackImage': '$id-back.jpg',
        'IDFrontUrl': idFrontUrl,
        'IDBackUrl': idBackUrl,
      });

      ToastComponent().showMessage(Colors.green, 'ID updated successfully.');
    } catch (e) {
      print('Error updating profile: $e');
      ToastComponent().showMessage(Colors.red, 'Error updating profile.');
    } finally {
      pd.close();
    }
  }

  @override
  Future<void> updateProfile1(Map<String, String> userData, bool isImage, BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Updating profile...');
    final user = _auth.currentUser;

    if (user == null) {
      ToastComponent().showMessage(Colors.red, 'User not logged in.');
      pd.close();
      return;
    }

    try {
      String id = user.uid;

      QuerySnapshot userDoc = await _firestore.collection('Users').where('Uid', isEqualTo: id).get();
      if (userDoc.docs.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'User document not found.');
        pd.close();
        return;
      }

      var profilepath = userData['profilepath'];


      if (profilepath == null) {
        ToastComponent().showMessage(Colors.red, 'ID paths are invalid.');
        pd.close();
        return;
      }

      Uint8List bytesIdFront = await File(profilepath).readAsBytes();
      Reference profileRef = FirebaseStorage.instance.ref().child('Profile/$id.jpg');

      // Delete existing files if they exist
      try {
        await profileRef.delete();
      } catch (e) {
        print('No existing front ID to delete.');
      }


      // Upload new files
      TaskSnapshot idFrontSnap = await profileRef.putData(bytesIdFront);

      String profileUrl = await idFrontSnap.ref.getDownloadURL();

      // Update Firestore with new URLs
      await _firestore.collection('Users').doc(id).update({
        'ProfileImage': '$id.jpg',
        'ProfileUrl': profileUrl,
      });

      ToastComponent().showMessage(Colors.green, 'Profile updated successfully.');
    } catch (e) {
      print('Error updating profile: $e');
      ToastComponent().showMessage(Colors.red, 'Error updating profile.');
    } finally {
      pd.close();
    }
  }
}