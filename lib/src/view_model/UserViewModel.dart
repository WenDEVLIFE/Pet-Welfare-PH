import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/model/UserModel.dart';
import 'package:pet_welfrare_ph/src/respository/AddUserRespository.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

class UserViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final AddUserRepository _addUserRepository = AddUserImpl();

  // Subscriptions
  List<UserModel> users = [];
  List<UserModel> filtereduser = [];

  // Get subscriptions
  List<UserModel> get getUser => filtereduser;

  // Stream of subscriptions
  Stream<List<UserModel>> get userStream => _addUserRepository.loadUserData();

  void navigateToAddAdmin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addAdmin);
  }

  // Filtered Search
  void filterUser(String query) {
     if (query.isNotEmpty) {
       filtereduser = users
           .where((user) =>
       user.name.toLowerCase().contains(query.toLowerCase()) ||
           user.email.toLowerCase().contains(query.toLowerCase()))
           .toList();
       notifyListeners();
     } else {
       filtereduser = users;
       notifyListeners();
     }
  }

}