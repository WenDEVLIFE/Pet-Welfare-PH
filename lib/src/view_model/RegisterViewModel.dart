import 'package:flutter/material.dart';

import '../helpers/Route.dart';

class RegisterViewModel extends ChangeNotifier {


  // Password Visibility
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isChecked = false;

  // Getter
  bool get obscureText1 => _obscureText1;
  bool get obscureText2 => _obscureText2;
  bool get isChecked => _isChecked;

  // Setter
  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }

  void proceedLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void proceedUploadID(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.uploadIDScreen);
  }
  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }


}