import 'package:flutter/cupertino.dart';

class ChangePasswordViewModel extends ChangeNotifier {

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool obscureText1 = true;
  bool obscureText2 = true;

  bool get isobscure1 => obscureText1;
  bool get isobscure2 => obscureText2;

  void togglePasswordVisibility1() {
    obscureText1 = !obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    obscureText2 = !obscureText2;
    notifyListeners();
  }

}