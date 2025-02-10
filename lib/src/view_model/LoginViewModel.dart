import 'package:flutter/material.dart';

import '../utils/Route.dart';

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

  void FetchData(BuildContext context){

    Navigator.pushReplacementNamed(context, AppRoutes.user);


  }

  void Login(BuildContext context){
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  void navigateToSelectView(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectScreen);
  }
}