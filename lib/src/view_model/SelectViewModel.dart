import 'package:flutter/widgets.dart';
import '../helpers/Route.dart';

class SelectViewModel extends ChangeNotifier {

  void navigateToFuRegistration(BuildContext context) {
    notifyListeners();
    Navigator.pushNamed(
      context,
      AppRoutes.furRegistrationScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }

  void navigateToShelterRegistration(BuildContext context) {
    // Implement navigation logic
  }

  void navigateToClinicRegistration(BuildContext context) {
    // Implement navigation logic
  }

  void navigateToAffiliateLaw(BuildContext context) {
    // Implement navigation logic
  }
}