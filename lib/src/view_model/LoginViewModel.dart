import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {

  // Password Visibility
  bool _obscureText1 = true;

  // Getter
  bool get obscureText1 => _obscureText1;

  // Setter
  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }
}