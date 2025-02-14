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
import 'package:sn_progress_dialog/progress_dialog.dart';

abstract class AddUserRepository {
  Future<bool> checkIfUserExists(String name, String email);
  Future<bool> checkValidateEmail(String email);
  Future<bool> checkPassword(String password, String confirmPassword);
  Future<bool> checkPasswordComplexity(String password);
  Future<void> registerUser(Map<String, dynamic> userData, BuildContext context, void Function() clearText);
  Stream<List<UserModel>> loadUserData();
}

class AddUserImpl implements AddUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This will check if the username exists in the database
  Future<bool> checkIfUserExists(String name, String email) async {
    final QuerySnapshot nameResult = await _firestore
        .collection('Users')
        .where('Name', isEqualTo: name)
        .get();

    final QuerySnapshot emailResult = await _firestore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();

    return nameResult.docs.isNotEmpty || emailResult.docs.isNotEmpty;
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
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    return RegExp(pattern).hasMatch(password);
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

      // Navigate to login screen
      if (role != "Admin" && role != "Super-Admin") {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }

      // Success message
      Fluttertoast.showToast(
        msg: 'Your account registered successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      clearText();
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

  // This will load the data of the user

}
