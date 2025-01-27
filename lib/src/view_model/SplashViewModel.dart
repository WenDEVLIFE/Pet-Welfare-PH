
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

      Fluttertoast.showToast(
        msg: 'Loading completed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}