import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';
import 'package:pet_welfrare_ph/src/utils/FirebaseIntialize.dart';
import 'package:pet_welfrare_ph/src/utils/NotificationUtils.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/ApplyAdoptionViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/CreatePostViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/DonateViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/DrawerHeadViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/AddAdminViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/ChangePasswordViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/OTPViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/LoginViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SelectViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/EstablishmentViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/LoadingViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SubcriptionViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UploadIDViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UserDataViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UserViewModel.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/widgets/NotificationListener.dart' as custom;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseRestAPI.run();
  await NotificationUtils.initNotifications();

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
        ChangeNotifierProvider(create: (_) => SelectViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UploadIDViewModel()),
        ChangeNotifierProvider(create: (_) => OTPViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => AddAdminViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => DrawerHeadViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => UserDataViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => EstablishmentViewModel()),
        ChangeNotifierProvider(create: (_) => ApplyAdoptionViewModel()),
        ChangeNotifierProvider(create: (_) => DonateViewModel()),
        ChangeNotifierProvider(create: (_) => MessageViewModel()),
        ChangeNotifierProvider(create: (_) => CreatePostViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel())
      ],
      child: Directionality(
        textDirection: TextDirection.ltr, // Provide a text direction
        child: Stack(
          children: [
            MaterialApp(
              key: GlobalKey(),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.loadingScreen,
              routes: AppRoutes.routes,
            ),
            custom.NotificationListener1(), // Use the custom NotificationListener widget
          ],
        ),
      ),
    );
  }
}