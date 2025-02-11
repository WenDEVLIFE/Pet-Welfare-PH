import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/SessionManager.dart';

abstract class Loadprofilerespository {
  Future<Map<String, dynamic>?> loadProfile();
}

class LoadProfileImpl implements Loadprofilerespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionManager sessionManager = SessionManager();

  @override
  Future<Map<String, dynamic>?> loadProfile() async {
    try {
      final user = await sessionManager.getUserInfo();
      String uid = user!['uid'];

      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
    return null;
  }
}