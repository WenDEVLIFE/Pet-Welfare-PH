import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {


  // Password Visibility
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  // Getter
  bool get obscureText1 => _obscureText1;
  bool get obscureText2 => _obscureText2;
}