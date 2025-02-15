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

  UserViewModel() {
    _listenToUserStream();
  }

  void _listenToUserStream() {
    userStream.listen((userList) {
      setUsers(userList);
      notifyListeners();
    });
  }

  void navigateToAddAdmin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addAdmin);
  }

  // Set users
  void setUsers(List<UserModel> userList) {
    users = userList;
    filteredUsers = userList;
    notifyListeners();
  }

  // Filtered Search
  void filterUser(String query) {
    if (query.isNotEmpty) {
      filteredUsers = users
          .where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredUsers = users;
    }
    notifyListeners();
  }

  // Filter by status
  void filterByStatus(int index) {
    switch (index) {
      case 0:
        filteredUsers = users.where((user) => user.status?.toLowerCase() == 'approved').toList();
        break;
      case 1:
        filteredUsers = users.where((user) => user.status?.toLowerCase() == 'pending').toList();
        break;
      case 2:
        filteredUsers = users.where((user) => user.status?.toLowerCase() == 'banned').toList();
        break;
      case 3:
        filteredUsers = users.where((user) => user.role?.toLowerCase() == 'admin' || user.role?.toLowerCase() == 'sub-admin').toList();
        break;
    }
    notifyListeners();
  }

  // Update status of user
  Future<void> updateStatus(String uid) async {
     await _addUserRepository.approveUser(uid);
  }
}