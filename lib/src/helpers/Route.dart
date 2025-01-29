import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/view/LoginView.dart';

import '../view/SplashView2.dart';
import '../view/LoadingView.dart';

class AppRoutes {
  static const String loadingScreen = '/loadingscreen';
  static const String splashscreen = '/splashscreen';
  static const String loginScreen = '/loginScreen';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    loadingScreen: (context) => LoadingView(), // Replace with actual screen
    splashscreen: (context) => SplashView2(), // Replace with actual screen
    loginScreen: (context) => const Loginview(), // Replace with actual screen
  };
}