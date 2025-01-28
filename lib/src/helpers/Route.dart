import 'package:flutter/cupertino.dart';

import '../view/LoginView.dart';
import '../view/SplashView.dart';

class AppRoutes {
  static const String splashScreen1 = '/splashscreen1';
  static const String loginScreen = '/loginScreen';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    splashScreen1: (context) => SplashScreen(), // Replace with actual screen
    loginScreen: (context) => LoginView(), // Replace with actual screen
  };
}