import 'package:flutter/cupertino.dart';

import '../view/SplashView.dart';

class AppRoutes {
  static const String splashScreen1 = '/splashscreen1';

  static Map<String, WidgetBuilder> routes = {
    splashScreen1: (context) => SplashScreen(), // Replace with actual screen
  };
}