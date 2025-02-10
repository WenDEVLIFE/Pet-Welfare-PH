
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInfo['email']);
    prefs.setString('role', userInfo['role']);
    prefs.setString('name', userInfo['name']);
    prefs.setString('uid', userInfo['uid']);
    print('User Info Saved');
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('email')) {
      return {
        'email': prefs.getString('email'),
        'role': prefs.getString('role'),
        'name': prefs.getString('name'),
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
    prefs.remove('name');
    prefs.remove('uid');

  }
}