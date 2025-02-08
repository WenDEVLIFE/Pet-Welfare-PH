import 'package:flutter/cupertino.dart';

class AddAdminViewModel extends ChangeNotifier {


  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final List<String> adminRole = ['Admin', 'Sub-Admin'];

  String? selectedRole;

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

  void setSelectedRole(String? value) {
    selectedRole = value;
    notifyListeners();
  }
}