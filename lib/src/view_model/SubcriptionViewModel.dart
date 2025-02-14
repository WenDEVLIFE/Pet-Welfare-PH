import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/respository/SubscriptionRespository.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import '../model/SubcriptionModel.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final TextEditingController subscriptionNameController = TextEditingController();
  final TextEditingController subscriptionPriceController = TextEditingController();
  final TextEditingController subscriptionDurationController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final SubscriptionRespository _subscriptionRespository = SubscriptinImpl();

  // Subscriptions
  List<SubscriptionModel> _subscriptions = [];
  List<SubscriptionModel> _filteredSubscriptions = [];

  // Get subscriptions
  List<SubscriptionModel> get subscriptionsdata => _filteredSubscriptions;

  // Stream of subscriptions
  Stream<List<SubscriptionModel>> get subscriptionsStream => _subscriptionRespository.getSubscriptions();

  // Set subscriptions
  void setSubscriptions(List<SubscriptionModel> subscriptions) {
    _subscriptions = subscriptions;
    filterSubscriptions(searchController.text);
    notifyListeners();
  }

  // Navigate to Add Subscription
  void addSubscriptionRoute(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.goToSubscription);
    notifyListeners();
  }

  // Add Subscription
  Future<void> addSubscription(BuildContext context) async {
    bool subscriptionExist = await _subscriptionRespository.checkIfSubscriptionExist(subscriptionNameController.text);

    if (subscriptionNameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Subscription Name is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (subscriptionExist) {
      print('Subscription already exist');
      Fluttertoast.showToast(
        msg: 'Subscription already exist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (subscriptionPriceController.text.isEmpty) {
      print('Subscription Price is empty');
      Fluttertoast.showToast(
        msg: 'Subscription Price is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (subscriptionDurationController.text.isEmpty) {
      print('Subscription Duration is empty');
      Fluttertoast.showToast(
        msg: 'Subscription Duration is empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      var subscriptionData = {
        'SubscriptionName': subscriptionNameController.text,
        'SubscriptionPrice': subscriptionPriceController.text,
        'SubscriptionDuration': subscriptionDurationController.text,
      };

      _subscriptionRespository.addSubscription(subscriptionData, context, clearTextFields);
    }
    notifyListeners();
  }

  // Update Subscription
  Future<void> updateSubscription(Map<String, String> subscriptionData, BuildContext context, String uid) async {
    bool subscriptionExist = await _subscriptionRespository.checkIfSubscriptionExist(subscriptionData['SubscriptionName']!);

    if (subscriptionExist) {
      Fluttertoast.showToast(
        msg: 'Subscription already exist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      _subscriptionRespository.updateSubscriptionData(subscriptionData, context, uid);
    }
    notifyListeners();
  }

  // Filter subscriptions
  void filterSubscriptions(String query) {
    if (query.isEmpty) {
      _filteredSubscriptions = _subscriptions;
    } else {
      _filteredSubscriptions = _subscriptions.where((subscription) {
        return subscription.subscriptionName.toLowerCase().contains(query.toLowerCase()) ||
            subscription.subscriptionAmount.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void deleteSubscription(BuildContext context, String uid) {
    _subscriptionRespository.deleteSubscription(context, uid);
  }

  void clearTextFields() {
    subscriptionNameController.clear();
    subscriptionPriceController.clear();
    subscriptionDurationController.clear();
  }
}