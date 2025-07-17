import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import '../utils/FirebaseIntialize.dart';
import '../views/AdminNavigationWidget.dart';
import '../views/UserNavigationComponent.dart';
import '../views/Loginview.dart';
import '../views/SplashView2.dart';

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

    if (user != null) {
      print('User: $user');

      if (user['role'] == 'Admin' || user['role'] == 'Sub-Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminNavigationWidget()),
        );
      } else if (user['role'] == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Loginview()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserNavigationComponent()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SplashView2(),
          settings: RouteSettings(arguments: {'key': 'value'}),
        ),
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
