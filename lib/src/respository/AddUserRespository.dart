import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> registerUser(String name, String email, String password) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the User ID (UID) from Firebase Authentication
      String uid = userCredential.user!.uid;

      // Store user info in Firestore
      await _firestore.collection("Users").doc(uid).set({
        "uid": uid,         // Store UID
        "name": name,       // Store Name
        "email": email,     // Store Email
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("User registered successfully!");
    } catch (e) {
      print("Error: $e");
    }
  }
}