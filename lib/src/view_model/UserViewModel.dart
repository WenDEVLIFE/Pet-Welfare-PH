import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/model/UserModel.dart';
import 'package:pet_welfrare_ph/src/respository/AddUserRespository.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

class UserViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final AddUserRepository _addUserRepository = AddUserImpl();

  // Users
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];

  // Get users
  List<UserModel> get getUser => filteredUsers;

  // Stream of users
  Stream<List<UserModel>> get userStream => _addUserRepository.loadUserData();

  void navigateToAddAdmin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addAdmin);
  }

  // Filtered Search
  void filterUser(String query) {
    if (query.isNotEmpty) {
      filteredUsers = users
          .where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      filteredUsers = users;
      notifyListeners();
    }
  }
}