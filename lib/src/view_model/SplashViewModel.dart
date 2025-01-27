
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void startLoading(BuildContext context) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () {
      _isLoading = false;
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/splashscreen1');
    });
  }
}