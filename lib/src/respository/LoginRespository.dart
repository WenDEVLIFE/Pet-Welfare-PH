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
    // Sign in
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Always get UID from FirebaseAuth directly
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('Error: No current user after login');
      return null;
    }

    final uid = user.uid;

    // Fetch Firestore user document
    final userDoc = await _firestore.collection('Users').doc(uid).get();

    if (!userDoc.exists) {
      print('Error: Firestore user document not found.');
      return null;
    }

    // Return parsed user data
    return {
      'uid': uid,
      'role': userDoc['Role'],
      'email': userDoc['Email'],
      'name': userDoc['Name'],
    };
  } catch (e) {
    print('Login failed: $e');
    return null;
  }
}

  
}