
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

  void startLoading(BuildContext context) async{
    _isLoading = true;
    notifyListeners();

    FirebaseRestAPI.run();

    Future.delayed(const Duration(seconds: 5), () async {
      final user = await sessionManager.getUserInfo();
      _isLoading = false;
      notifyListeners();

      // Check if user is already logged in
       if (user != null) {

         if (user['role'] == 'Admin' || user['role'] == 'Sub-Admin') {
           Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
         } else {
           Navigator.pushReplacementNamed(context, AppRoutes.user);
         }
       }

       // If user is not logged in, redirect to splash screen
       else{
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
    });
  }
}