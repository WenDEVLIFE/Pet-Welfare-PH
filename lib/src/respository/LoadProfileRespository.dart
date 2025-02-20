import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/SessionManager.dart';

abstract class Loadprofilerespository {
  Stream<Map<String, dynamic>?> loadProfile();
  Stream<Map<String, dynamic>?> loadProfile1();
}

class LoadProfileImpl implements Loadprofilerespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionManager sessionManager = SessionManager();

  @override
  Stream<Map<String, dynamic>?> loadProfile() async* {
    final user = await sessionManager.getUserInfo();
    String uid = user!['uid'];

    yield* _firestore.collection('Users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
      return null;
    });
  }

  @override
  Stream<Map<String, dynamic>?> loadProfile1() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    String uid = user.uid;

    return _firestore.collection('Users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
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
      return null;
    });
  }
}