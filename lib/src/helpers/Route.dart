import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/view/FurParentRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/LoginView.dart';
import 'package:pet_welfrare_ph/src/view/SelectView.dart';

import '../view/SplashView.dart';
import '../view/LoadingView.dart';

class AppRoutes {
  static const String loadingScreen = '/loadingscreen';
  static const String splashscreen = '/splashscreen';
  static const String loginScreen = '/loginScreen';
  static const String selectScreen = '/selectScreen';
  static const String furRegistrationScreen = '/furRegistrationScreen';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    loadingScreen: (context) => LoadingView(), // Replace with actual screen
    splashscreen: (context) => SplashView2(), // Replace with actual screen
    loginScreen: (context) => const Loginview(), // Replace with actual screen
    selectScreen: (context) => const SelectView(), // Replace with actual screen
    furRegistrationScreen: (context) => const FurParentRegisterView(), // Replace with actual screen
  };
}