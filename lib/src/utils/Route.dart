import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/components/UserNavigationComponent.dart';
import 'package:pet_welfrare_ph/src/view/DashboardView.dart';
import 'package:pet_welfrare_ph/src/view/FurParentRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/HomeScreen.dart';
import 'package:pet_welfrare_ph/src/view/LegalFirmRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/LoginView.dart';
import 'package:pet_welfrare_ph/src/view/PetR_Shelter_RegisterView.dart';
import 'package:pet_welfrare_ph/src/view/PrivacyView.dart';
import 'package:pet_welfrare_ph/src/view/ProfileView.dart';
import 'package:pet_welfrare_ph/src/view/SelectView.dart';
import 'package:pet_welfrare_ph/src/view/TermsAndConditionView.dart';
import 'package:pet_welfrare_ph/src/view/UploadIDView.dart';
import 'package:pet_welfrare_ph/src/view/VetClinicRegisterView.dart';

import '../components/AdminNavigationComponent.dart';
import '../view/AddAdminView.dart';
import '../view/ChangePasswordView.dart';
import '../view/OTPView.dart';
import '../view/SplashView.dart';
import '../view/LoadingView.dart';
import '../view/SubscriptionView.dart';
import '../view/UserView.dart';

class AppRoutes {
  static const String loadingScreen = '/loadingscreen';
  static const String splashscreen = '/splashscreen';
  static const String loginScreen = '/loginScreen';
  static const String selectScreen = '/selectScreen';
  static const String furRegistrationScreen = '/furRegistrationScreen';
  static const String shelterRegistrationScreen = '/shelterRegistrationScreen';
  static const String clinicRegistrationScreen = '/clinicRegistrationScreen';
  static const String legalScreen = '/legalScreen';
  static const String uploadIDScreen = '/uploadIDScreen';
  static const String otpScreen = '/otpScreen';
  static const String user = '/UserNaview';
  static const String admin = '/AdminNaview';
  static const String termsAndConditions = '/termsAndConditions';
  static const String privacyPolicy = '/privacyPolicy';
  static const String changePassword = '/changePassword';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String homescreen = '/homescreen';
  static const String userView = '/userView';
  static const String addAdmin = '/addAdmin';
  static const String subscription = '/subscription';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    loadingScreen: (context) => LoadingView(), // Replace with actual screen
    splashscreen: (context) => SplashView2(), // Replace with actual screen
    loginScreen: (context) => const Loginview(), // Replace with actual screen
    selectScreen: (context) => const SelectView(), // Replace with actual screen
    furRegistrationScreen: (context) => const FurParentRegisterView(), // Replace with actual screen
    shelterRegistrationScreen: (context) => const PetrShelterRegisterview(), // Replace with actual screen
    clinicRegistrationScreen: (context) => const VetClinicRegisterView(), // Replace with actual screen
    legalScreen: (context) => const LegalFirmRegisterView(), // Replace with actual screen
    uploadIDScreen: (context) => const UploadIDView(), // Replace with actual screen
    otpScreen: (context) => const OTPView(), // Replace with actual screen
    user: (context) => const UserNavigationComponent(), // Replace with actual screen
    admin: (context) => const AdminNavigationComponent(), // Replace with actual screen
    termsAndConditions: (context) => const TermsAndConditionView(), // Replace with actual screen
    privacyPolicy: (context) => const Privacyview(), // Replace with actual screen
    changePassword: (context) => const ChangePasswordView(), // Replace with actual screen
    profile: (context) => const ProfileView(), // Replace with actual screen
    dashboard: (context) => const DashboardView(), // Replace with actual screen
    homescreen: (context) => const HomeScreen(), // Replace with actual screen
    userView: (context) => const UserView(), // Replace with actual screen
    addAdmin: (context) => const AddAdminView(), // Replace with actual screen
    subscription : (context) => const SubscriptionView(), // Replace with actual screen
  };
}