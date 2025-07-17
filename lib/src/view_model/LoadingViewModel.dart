import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';

import '../utils/FirebaseIntialize.dart';
import '../utils/Route.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final SessionManager sessionManager = SessionManager();

  void startLoading(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    FirebaseRestAPI.run();

    await Future.delayed(const Duration(seconds: 5));

    final user = await sessionManager.getUserInfo();
    _isLoading = false;
    notifyListeners();

    // Check if user is already logged in
    if (user != null) {
      print('User: $user');

      if (user['role'] == 'Admin' || user['role'] == 'Sub-Admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else if (user['role'] == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.user);
      }
    } else {
      // If user is not logged in, redirect to splash screen
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.splashscreen,
        arguments: {'key': 'value'}, // Pass a map or any data
      );
    }

    Fluttertoast.showToast(
      msg: 'Loading completed',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}