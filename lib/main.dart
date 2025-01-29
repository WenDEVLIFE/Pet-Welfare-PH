import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/helpers/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/LoginViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel2.dart';
import 'package:pet_welfrare_ph/src/view_model/LoadingViewModel.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel2()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.loadingScreen,
        routes: AppRoutes.routes,
      ),
    );
  }
}