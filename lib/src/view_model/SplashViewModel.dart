import 'package:flutter/cupertino.dart';

import '../helpers/Route.dart';

class SplashViewModel2 extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  void navigateLogin(BuildContext context) {
    notifyListeners();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.loginScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }
}

