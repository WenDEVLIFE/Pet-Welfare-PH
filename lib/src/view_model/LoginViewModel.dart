import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureText1 = true;
  void togglePasswordVisibility1() {
    obscureText1 = !obscureText1;
    notifyListeners();
  }
}