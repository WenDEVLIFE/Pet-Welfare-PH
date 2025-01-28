import 'package:flutter/cupertino.dart';

import '../view/SplashView2.dart';
import '../view/SplashView.dart';

class AppRoutes {
  static const String splashScreen1 = '/splashscreen1';
  static const String loginScreen = '/loginScreen';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    splashScreen1: (context) => SplashScreen(), // Replace with actual screen
    loginScreen: (context) => SplashView2(), // Replace with actual screen
  };
}