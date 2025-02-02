import 'package:flutter/widgets.dart';
import '../utils/Route.dart';

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
    notifyListeners();
    Navigator.pushNamed(
      context,
      AppRoutes.shelterRegistrationScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }

  void navigateToClinicRegistration(BuildContext context) {
    // Implement navigation logic
    notifyListeners();
    Navigator.pushNamed(
      context,
      AppRoutes.clinicRegistrationScreen,
      arguments: {'key': 'value'}, // Pass a map or any data
    );
  }

  void navigateToAffiliateLaw(BuildContext context) {
    // Implement navigation logic
    notifyListeners();
    Navigator.pushNamed(
      context,
        AppRoutes.legalScreen,
        arguments: {'key': 'value'}, // Pass a map or any data
    );
  }
}