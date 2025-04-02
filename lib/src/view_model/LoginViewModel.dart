import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/LoginRespository.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:sn_progress_dialog/enums/progress_types.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../utils/Route.dart';
import '../widgets/NotificationListener.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginRepository loginRepository = LoginRepositoryImpl();
  final SessionManager sessionManager = SessionManager();

  // Password Visibility
  bool _obscureText1 = true;

  // Getter
  bool get obscureText1 => _obscureText1;

  // Setter
  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    // Simple check for empty credentials before attempting login
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    try {
      Map<String, dynamic>? userData = await loginRepository.login(email, password);

      if (userData != null) {
        print(userData);
        // Save user info
        await sessionManager.saveUserInfo(userData);

        // If login is successful, navigate based on user role
        if (userData['role'] == 'Admin' || userData['role'] == 'Sub-Admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          clearTextFields();

        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.user);
          clearTextFields();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        NotificationListener1();
      } else {
        // Show error message if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (e) {
      // Handle any error that occurs during login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  void navigateToSelectView(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectScreen);
  }

  void clearTextFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}