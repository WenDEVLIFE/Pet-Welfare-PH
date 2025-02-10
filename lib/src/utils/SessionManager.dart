
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInfo['email']);
    prefs.setString('role', userInfo['role']);
    prefs.setString('uid', userInfo['uid']);
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('email')) {
      return {
        'email': prefs.getString('email'),
        'role': prefs.getString('role'),
        'uid': prefs.getString('uid')
      };
    }
    return null;
  }

  Future <void> updateEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  Future<void> clearUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('role');
    prefs.remove('uid');

  }
}