import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

class SubscriptionViewModel extends ChangeNotifier {

  final TextEditingController subscriptionNameController = TextEditingController();

  final TextEditingController subscriptionPriceController = TextEditingController();

  final TextEditingController subscriptionDurationController = TextEditingController();

  // Navigate to Add Subscription
  void addSubscriptionRoute(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.goToSubscription);
  }

}