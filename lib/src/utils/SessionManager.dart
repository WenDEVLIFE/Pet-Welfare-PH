import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInfo['email']);
    prefs.setString('role', userInfo['role']);
    prefs.setString('name', userInfo['name']);
    print('User Info Saved');
  }

  /// Always fetch the UID directly from FirebaseAuth
  String? getCurrentUid() {
    return _auth.currentUser?.uid;
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = getCurrentUid(); // Get real-time uid
    if (prefs.containsKey('email') && uid != null) {
      return {
        'email': prefs.getString('email'),
        'role': prefs.getString('role'),
        'name': prefs.getString('name'),
        'uid': uid, // Never from SharedPreferences
      };
    }
    return null;
  }

  Future<void> updateEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  Future<void> clearUserInfo() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Sign out failed: $e");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
