import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

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

  Future <void> updatePassword(BuildContext context) async {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      // Show error message
      ToastComponent().showMessage(Colors.red, 'Please fill in all fields');
      return;
    }

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      // Show success message
      ToastComponent().showMessage(AppColors.orange, 'Password updated successfully');
    } catch (e) {
      // Handle errors
    }
  }

}