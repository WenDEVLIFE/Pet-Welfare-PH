import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/SessionManager.dart';

abstract class Loadprofilerespository {
  Future<Map<String, dynamic>?> loadProfile();
  Future<Map<String, dynamic>?> loadProfile1();
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

  @override
  Future<Map<String, dynamic>?> loadProfile1() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in.');
      }
      String uid = user.uid;

      print('uid: $uid');

      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return {
          'name': data['Name'] ?? '',
          'email': data['Email'] ?? '',
          'idType': data['IDType'] ?? '',
          'profilepath': data['ProfileUrl'] ?? '',
          'idfrontpath': data['IDFrontUrl'] ?? '',
          'idbackpath': data['IDBackUrl'] ?? '',
          'role': data['Role'] ?? '',
          'address': data.containsKey('Address') ? data['Address'] : '',
          'status': data.containsKey('Status') ? data['Status'] : '',
        };
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
    return null;
  }
}