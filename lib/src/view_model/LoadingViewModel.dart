import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import '../utils/FirebaseIntialize.dart';

import 'package:pet_welfrare_ph/src/view/admindirectory/ReportView.dart';
import 'package:pet_welfrare_ph/src/widgets/UserNavigationComponent.dart';
import 'package:pet_welfrare_ph/src/view/admindirectory/AddSubscriptionView.dart';
import 'package:pet_welfrare_ph/src/view/admindirectory/DashboardView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/CreatePostView.dart';
import 'package:pet_welfrare_ph/src/view/registerDirectory/FurParentRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/HomeScreen.dart';
import 'package:pet_welfrare_ph/src/view/registerDirectory/LegalFirmRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/LoginView.dart';
import 'package:pet_welfrare_ph/src/view/registerDirectory/PetR_Shelter_RegisterView.dart';
import 'package:pet_welfrare_ph/src/view/PrivacyView.dart';
import 'package:pet_welfrare_ph/src/view/MyPostView.dart';
import 'package:pet_welfrare_ph/src/view/SelectView.dart';
import 'package:pet_welfrare_ph/src/view/TermsAndConditionView.dart';
import 'package:pet_welfrare_ph/src/view/UploadIDView.dart';
import 'package:pet_welfrare_ph/src/view/registerDirectory/VetClinicRegisterView.dart';
import 'package:pet_welfrare_ph/src/view/ViewEstablishment.dart';
import 'package:pet_welfrare_ph/src/view/ViewImage.dart';
import 'package:pet_welfrare_ph/src/view/ViewUserData.dart';
import 'package:pet_welfrare_ph/src/view/ViewUserScreen.dart';
import 'package:pet_welfrare_ph/src/view/ApprovedEstablismentView.dart';

import '../view/NotificationView.dart';
import '../widgets/AdminNavigationComponent.dart';
import '../view/AboutView.dart';
import '../view/admindirectory/AddAdminView.dart';
import '../view/AddBusinessView.dart';
import '../view/editdirectory/ChangeIDView.dart';
import '../view/ChangePasswordView.dart';
import '../view/chatdirectory/ChatView.dart';
import '../view/editdirectory/EditBusinessView.dart';
import '../view/chatdirectory/MessageView.dart';
import '../view/OTPView.dart';
import '../view/UserEstablismentView.dart';
import '../view/SplashView.dart';
import '../view/LoadingView.dart';
import '../view/admindirectory/SubscriptionView.dart';
import '../view/UserView.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final SessionManager sessionManager = SessionManager();

  void startLoading(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    FirebaseRestAPI.run();

    await Future.delayed(const Duration(seconds: 5));

    final user = await sessionManager.getUserInfo();
    _isLoading = false;
    notifyListeners();

    if (user != null) {
      print('User: $user');

      if (user['role'] == 'Admin' || user['role'] == 'Sub-Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminNavigationWidget()),
        );
      } else if (user['role'] == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Loginview()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserNavigationComponent()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SplashView2(),
          settings: RouteSettings(arguments: {'key': 'value'}),
        ),
      );
    }

    Fluttertoast.showToast(
      msg: 'Loading completed',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
