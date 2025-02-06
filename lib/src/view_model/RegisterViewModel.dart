import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/Route.dart';

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

  void showTermsAndConditionDialog(BuildContext context) async {
    String termsText = await loadTermsAndConditions();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Terms and Conditions"),
          content: SingleChildScrollView(
            child: Text(termsText, textAlign: TextAlign.justify),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<String> loadTermsAndConditions() async {
    // Load text from the text file
    String text = await rootBundle.loadString("assets/word/terms.txt");
    return text;
  }
}