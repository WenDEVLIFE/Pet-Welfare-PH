
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkIfUserExists(String name, String email) async {
    final QuerySnapshot result = await _firestore
        .collection('Users')
        .where('Name', isEqualTo: name)
        .where('Email', isEqualTo: email)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  Future <bool> checkValidateEmail(String email) async {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Future <bool> checkPassword(String password, String confirmPassword) async {
    return password == confirmPassword;
  }

  Future <bool> checkPasswordComplexity(String password) async {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  Future<void> registerUser(Map<String, String?> userData, BuildContext context, void Function() clearText) async {

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Registering User...',
    );


    try {
      // Create user in Firebase Authentication
      var email = userData['email']!;
      var password = userData['password']!;
      var name = userData['name']!;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the User ID (UID) from Firebase Authentication
      String uid = userCredential.user!.uid;

      ByteData data = await rootBundle.load('assets/images/cat.jpg');
      Uint8List bytes = data.buffer.asUint8List();
      // Upload Image to Firebase Storage
      String fileName = '$uid.jpg';
      Reference reference = FirebaseStorage.instance.ref().child('Profile').child(fileName);
      UploadTask uploadTask = reference.putData(bytes);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      // Store user info in Firestore
      await _firestore.collection("Users").doc(uid).set({
        "Uid": uid,         // Store UID
        "Name": name,       // Store Name
        "Email": email,     // Store Email
        'ProfileUrl': downloadUrl,
        'ProfileImage': fileName,
        "CreatedAt": FieldValue.serverTimestamp(),
      });

      print("User registered successfully!");
      Fluttertoast.showToast(
        msg: 'User registered successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      clearText();
    } catch (e) {
      print("Error: $e");
    }
    finally {
      pd.close();
    }
  }
}