import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/components/UserNavigationComponent.dart';
import 'package:pet_welfrare_ph/src/view/AddSubscriptionView.dart';
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
import 'package:pet_welfrare_ph/src/view/ViewUserData.dart';
import 'package:pet_welfrare_ph/src/view/ViewUserDataDialog.dart';

import '../components/AdminNavigationComponent.dart';
import '../view/AboutView.dart';
import '../view/AddAdminView.dart';
import '../view/AddShelterClinicScreen.dart';
import '../view/ChangeIDView.dart';
import '../view/ChangePasswordView.dart';
import '../view/OTPView.dart';
import '../view/Shelter_Clinic_View.dart';
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
  static const String goToSubscription = '/goToSubscription';
  static const String viewUserData = '/ViewUserData';
  static const String about = '/about';
  static const String viewUserInformation = '/viewUserInformation';
  static const String changeID = '/changeID';
  static const String shelterClinic = '/shelterClinic';
  static const String addSherterClinic = '/addSherterClinic';

  // Assign routes to the screens
  static Map<String, WidgetBuilder> routes = {
    loadingScreen: (context) => LoadingView(),// This is the loading screen
    splashscreen: (context) => SplashView2(), // This is the splash screen
    loginScreen: (context) => const Loginview(),  // This is the login screen
    selectScreen: (context) => const SelectView(), // This is the select screen
    furRegistrationScreen: (context) => const FurParentRegisterView(),  // This is the fur parent registration screen
    shelterRegistrationScreen: (context) => const PetrShelterRegisterview(),  // This is the pet shelter registration screen
    clinicRegistrationScreen: (context) => const VetClinicRegisterView(),  // This is the vet clinic registration screen
    legalScreen: (context) => const LegalFirmRegisterView(), // This is the legal firm registration screen
    uploadIDScreen: (context) => const UploadIDView(), //  This is the upload ID screen
    otpScreen: (context) => const OTPView(), //  This is the OTP screen
    user: (context) => const UserNavigationComponent(), //  This is the user navigation component
    admin: (context) => const AdminNavigationComponent(), //  This is the admin navigation component
    termsAndConditions: (context) => const TermsAndConditionView(), //  This is the terms and conditions
    privacyPolicy: (context) => const Privacyview(), //  This is the privacy policy
    changePassword: (context) => const ChangePasswordView(), //  This is the change password
    profile: (context) => const ProfileView(), //  This is the profile
    dashboard: (context) => const DashboardView(), // This is the dashboard
    homescreen: (context) => const HomeScreen(), // This is the home screen
    userView: (context) => const UserView(), // This is where the admin can view the user
    addAdmin: (context) => const AddAdminView(), // This is where the admin can add another admin
    subscription : (context) => const SubscriptionView(), // // This is where the user can go to the subscription page
    goToSubscription : (context) => const AddSubscriptionView(),// This is where the user can go to the add subscription page
    viewUserData : (context) => const ViewUserDataPage(), // This is where the admin can view the user data
    about : (context) => const AboutView(), // About page
    viewUserInformation : (context) => const ViewUserData(), // This is where the user can view its status
    changeID : (context) => const ChangeIDView(), // This is where the user can change its ID
    shelterClinic : (context) => const Shelter_Clinic_View(), // This is where the user can view the shelter clinic
    addSherterClinic : (context) => const AddShelterClinic(), // This is where the user can add the shelter clinic
  };
}