import 'package:flutter/cupertino.dart';
import '../respository/LoadProfileRespository.dart';

class DrawerHeadViewModel extends ChangeNotifier {
  final Loadprofilerespository _loadProfileRepository = LoadProfileImpl();

  String name = "name";
  String role = "role";
  String profileImage = "profileImage";

  // Load profile data
  void loadData() {
    _loadProfileRepository.loadProfile().listen((profileData) {
      if (profileData != null) {
        name = profileData['Name'] ?? "Name";
        role = profileData['Role'] ?? "Role";
        profileImage = profileData['ProfileUrl'] ?? "ProfileUrl";
        print('Profile Data: $profileData');
        notifyListeners();
      } else {
        print('Profile Data is null');
      }
    });
  }
}