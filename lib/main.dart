import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/helpers/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel2.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel2()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen1,
        routes: AppRoutes.routes,
      ),
    );
  }
}