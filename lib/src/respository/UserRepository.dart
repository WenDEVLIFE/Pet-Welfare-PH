import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/model/UserModel.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase_admin/firebase_admin.dart' as admin;

abstract class UserRepository {
  Future<bool> checkIfUserExists(String name, String email);
  Future<bool> checkValidateEmail(String email);
  Future<bool> checkPassword(String password, String confirmPassword);
  Future<bool> checkPasswordComplexity(String password);
  Future<void> registerUser(Map<String, dynamic> userData, BuildContext context, void Function() clearText);
  Stream<List<UserModel>> loadUserData();
  Future<void> approveUser(String uid);
  Future<void> deniedUser(String uid);
  Future<void> deleteUser(String uid);
  Future<void > executeBan(String uid, String text);
  Future<void> unBanUser(String uid);

  Future<bool> checkPhoneNumber(String phoneNumber);
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
 //  final admin.App _adminApp = admin.initializeApp();

  // This will check if the username exists in the database
  Future<bool> checkIfUserExists(String name, String email) async {

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: 'admin@gmail.com',
      password: '@WenDEVLIFE123',
    );

    User? user = userCredential.user;
     if (user != null) {
       final QuerySnapshot nameResult = await _firestore
           .collection('Users')
           .where('Name', isEqualTo: name)
           .get();

       final QuerySnapshot emailResult = await _firestore
           .collection('Users')
           .where('Email', isEqualTo: email)
           .get();

       return nameResult.docs.isNotEmpty || emailResult.docs.isNotEmpty;;
     } else {
       return false;
     }
  }

  // This will check if the email is valid
  Future<bool> checkValidateEmail(String email) async {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(email);
  }

  // This will check if the password and confirm password are the same
  Future<bool> checkPassword(String password, String confirmPassword) async {
    return password == confirmPassword;
  }

  // This will check if the password is complex
  Future<bool> checkPasswordComplexity(String password) async {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~%^&*()_+|<>?{}\\[\\]~-;:+=-]).{8,}$';
    return RegExp(pattern).hasMatch(password);
  }

  // Check if the phone number is valid
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    String pattern = r'^[0-9]{11}$';
    return RegExp(pattern).hasMatch(phoneNumber);
  }

  // This will register the user
  Future<void> registerUser(Map<String, dynamic> userData, BuildContext context, void Function() clearText) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Registering User...');

    try {
      // Extract user data


      var email = userData['email']!;
      var password = userData['password']!;
      var name = userData['name']!;
      var role = userData['role']!;
      var idbackPath = userData['idback']!;
      var idfrontPath = userData['idfront']!;
      var address = userData['address']!;
      var idType = userData['selectIDtype']!;
      final Function clearData = userData['clearData'];
      final Function clearFields = userData['clearFields'];

      // Navigate to login screen
      if (role != "Admin" && role != "Super-Admin") {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }

      // Register user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the UID
      String uid = userCredential.user!.uid;

      // Convert images to Uint8List
      ByteData data = await rootBundle.load('assets/images/cat.jpg');
      Uint8List bytes = data.buffer.asUint8List();
      Uint8List bytesIdFront = await File(idfrontPath).readAsBytes();
      Uint8List bytesIdBack = await File(idbackPath).readAsBytes();

      // Upload to Firebase Storage
      Reference profileRef = FirebaseStorage.instance.ref().child('Profile/$uid.jpg');
      Reference idFrontRef = FirebaseStorage.instance.ref().child('ID/$uid-front.jpg');
      Reference idBackRef = FirebaseStorage.instance.ref().child('ID/$uid-back.jpg');

      TaskSnapshot profileSnap = await profileRef.putData(bytes);
      TaskSnapshot idFrontSnap = await idFrontRef.putData(bytesIdFront);
      TaskSnapshot idBackSnap = await idBackRef.putData(bytesIdBack);

      String profileUrl = await profileSnap.ref.getDownloadURL();
      String idFrontUrl = await idFrontSnap.ref.getDownloadURL();
      String idBackUrl = await idBackSnap.ref.getDownloadURL();

      // Set expiration date (6-month free trial)
      DateTime expiryDate = DateTime.now().add(const Duration(days: 180));

      // User Firestore Data
      Map<String, dynamic> userFirestoreData = {
        "Uid": uid,
        "Name": name,
        "Email": email,
        "ProfileUrl": profileUrl,
        "ProfileImage": "$uid.jpg",
        "IDFrontImage": "$uid-front.jpg",
        "IDBackImage": "$uid-back.jpg",
        "IDFrontUrl": idFrontUrl,
        "IDBackUrl": idBackUrl,
        "IDType": idType,
        "Role": role,
        "CreatedAt": FieldValue.serverTimestamp(),
        if (role != "Admin" && role != "Super-Admin" ) ...{
          if (role == "Pet Rescuer" && role == "Pet Shelter") "Address": address,
          "SubscriptionExpiresAt": Timestamp.fromDate(expiryDate),
          "SubscriptionType": "Free Trial",
          "Status": "Pending",
        }
      };

      // Add to Firestore
      await _firestore.collection("Users").doc(uid).set(userFirestoreData);

      if (role != "Admin" && role != "Super-Admin") {
        clearData();
        clearFields();

        // Success message
        ToastComponent().showMessage(Colors.green, 'User registered successfully!');
      }
      else{
        ToastComponent().showMessage(Colors.green, 'Admin added successfully!');
        clearText();
      }
    } catch (e) {
      print("Error: $e");
     ToastComponent().showMessage(Colors.red, 'Error: $e');
    } finally {
      pd.close();
    }
  }

  @override
  Stream<List<UserModel>> loadUserData() {
     // This will load the data of the user
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  // This will approve the user
  Future<void> approveUser(String uid) async {
    QuerySnapshot nameResult = await _firestore
        .collection('Users')
        .where('Uid', isEqualTo: uid)
        .get();

    if (nameResult.docs.isNotEmpty) {
      var status = nameResult.docs.first.get('Status');

      if (status == 'Pending') {
        await _firestore.collection('Users').doc(uid).update(
            {'Status': 'Approved'});
        ToastComponent().showMessage(Colors.green, 'User approved successfully!');
      } else {
        ToastComponent().showMessage(Colors.red, 'User is already approved!');
      }
    }
  }

  // This will deny the user
 Future<void> deniedUser(String uid) async {
    QuerySnapshot nameResult = await _firestore
        .collection('Users')
        .where('Uid', isEqualTo: uid)
        .get();

    if (nameResult.docs.isNotEmpty) {
      var status = nameResult.docs.first.get('Status');

      if (status == 'Pending' || status == 'Approved') {
        await _firestore.collection('Users').doc(uid).update({'Status': 'Denied'});

        ToastComponent().showMessage(Colors.green, 'User denied successfully!');
      } else {
         ToastComponent().showMessage(Colors.red, 'User is already denied!');
      }
    }
  }

  // This will delete the user
  Future<void> deleteUser(String uid) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Delete Firestore user data
      QuerySnapshot userResult = await _firestore
          .collection('Users')
          .where('Uid', isEqualTo: uid)
          .get();

      if (userResult.docs.isNotEmpty) {
        // Delete user files from Firebase Storage
        Reference profileRef = storage.ref().child("Profile/$uid.jpg");
        Reference idFrontRef = storage.ref().child("ID/$uid-front.jpg");
        Reference idBackRef = storage.ref().child("ID/$uid-back.jpg");
        await profileRef.delete();
        await idFrontRef.delete();
        await idBackRef.delete();

        // Delete user document from Firestore
        await _firestore.collection('Users').doc(uid).delete();
        print('User document deleted from Firestore');

        ToastComponent().showMessage(Colors.green, 'User deleted successfully!');
      } else {
        print('User not found');
        ToastComponent().showMessage(Colors.red, 'User not found!');
      }
    } catch (e) {
      print("Error deleting user: $e");
      ToastComponent().showMessage(Colors.red, 'Error: $e');
    }
  }

  Future<void> executeBan(String uid, String reason) async {
    try {
      // Check if the user is already banned
      QuerySnapshot bannedResult = await _firestore
          .collection('Banned')
          .where('Uid', isEqualTo: uid)
          .get();

      if (bannedResult.docs.isNotEmpty) {
        ToastComponent().showMessage(Colors.red, 'User is already banned!');
        return;
      } else{
        // Proceed with banning the user
        await _firestore.collection('Banned').add({
          'Uid': uid,
          'Reason': reason,
          'CreatedAt': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('Users').doc(uid).update({'Status': 'Banned'});

        ToastComponent().showMessage(Colors.green, 'User banned successfully!');

      }
    } catch (e) {
      print("Error banning user: $e");
      ToastComponent().showMessage(Colors.red, 'Error: $e');
    }
  }

  Future<void> unBanUser(String uid) async {
    try {
      // Check if the user is already banned
      QuerySnapshot bannedResult = await _firestore
          .collection('Banned')
          .where('Uid', isEqualTo: uid)
          .get();

      if (bannedResult.docs.isNotEmpty) {
        bannedResult.docs.forEach((doc) async {
          await doc.reference.delete();
        });
        await _firestore.collection('Users').doc(uid).update({'Status': 'Approved'});

        ToastComponent().showMessage(Colors.green, 'User unbanned successfully!');
      } else {
        ToastComponent().showMessage(Colors.red, 'User is not banned!');
      }
    } catch (e) {
      print("Error unbanning user: $e");
      ToastComponent().showMessage(Colors.red, 'Error: $e');
    }
  }

}
