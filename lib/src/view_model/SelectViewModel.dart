import 'package:flutter/widgets.dart';
import '../helpers/Route.dart';

class SelectViewModel extends ChangeNotifier {

  void navigateToFuRegistration(BuildContext context) {
    notifyListeners();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.furRegistrationScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }

  void navigateToShelterRegistration(BuildContext context) {
    // Implement navigation logic
    notifyListeners();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.shelterRegistrationScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }

  void navigateToClinicRegistration(BuildContext context) {
    // Implement navigation logic
  }

  void navigateToAffiliateLaw(BuildContext context) {
    // Implement navigation logic
  }
}