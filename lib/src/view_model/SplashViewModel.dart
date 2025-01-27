
import 'package:flutter/material.dart';

import '../helpers/Route.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void startLoading(BuildContext context) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () {
      _isLoading = false;
      notifyListeners();
      Navigator.pushNamed(
        context,
        AppRoutes.splashScreen1,
        arguments: {'key': 'value'}, // Pass a map or any data
      );
    });
  }
}