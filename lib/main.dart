import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/helpers/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/LoginViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen1,
        routes: AppRoutes.routes,
      ),
    );
  }
}