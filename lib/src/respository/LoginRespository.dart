import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepository {
  Future<Map<String, dynamic>?> login(String email, String password);
}

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the User ID (UID) from Firebase Authentication
      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        // Extract user data
        String role = userDoc['Role'];
        String email = userDoc['Email'];

        // Return user data
        return {
          'id': uid,
          'role': role,
          'email': email,
        };
      } else {
        // User document does not exist in Firestore
        return null;
      }
    } catch (e) {
      // Handle errors (e.g., user not found, wrong password)
      print('Error: $e');
      return null;
    }
  }
}