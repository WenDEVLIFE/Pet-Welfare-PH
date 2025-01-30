import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {


  // Password Visibility
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  // Getter
  bool get obscureText1 => _obscureText1;
  bool get obscureText2 => _obscureText2;

  // Setter
  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }
}