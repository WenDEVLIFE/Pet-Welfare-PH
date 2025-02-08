
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/FirebaseIntialize.dart';
import '../utils/Route.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void startLoading(BuildContext context) async{
    _isLoading = true;
    notifyListeners();

    await FirebaseRestAPI.run();

    Future.delayed(const Duration(seconds: 5), () {
      _isLoading = false;
      notifyListeners();
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboard,
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