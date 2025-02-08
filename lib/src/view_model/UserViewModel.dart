import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

class UserViewModel extends ChangeNotifier {

  void navigateToAddAdmin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addAdmin);
  }

}