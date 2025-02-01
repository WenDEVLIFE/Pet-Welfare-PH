import 'package:flutter/material.dart';

import '../helpers/Route.dart';
import '../utils/TermsAndConditionDialog.dart';

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

  void showTermsAndConditionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TermsAndConditionDialog(
          title: 'Terms and Conditions',
          content: 'By clicking "Accept", you agree to the following:\n\n'
              '- You must be 13 years old or older to use this service\n'
              '- You must be a pet shelter or pet rescuer\n'
              '- You must agree to the terms and conditions\n'
              '- You must agree to the privacy policy\n'
              '- You must agree to the cookie policy\n'
              '- You must agree to the GDPR policy\n'
              '- You must agree to the terms of service\n',
          buttonText1: 'Accept',
          buttonText2: 'Cancel',
          onAccept: () {
            Navigator.of(context).pop();
            // Handle the accept action here
            setChecked(true);
          },
          onDecline: () {
            Navigator.of(context).pop();
            // Handle the decline action here
          },
          imagePath: 'assets/icon/Logo.png',
        );
      },
    );
  }




}