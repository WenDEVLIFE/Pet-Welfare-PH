import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../respository/LoadProfileRespository.dart';

class MenuViewModel extends ChangeNotifier {
  final Loadprofilerespository _loadProfileRepository = LoadProfileImpl();
  final ImagePicker imagePicker = ImagePicker();
  String currentfilepath = '';
  String name = "";
  String role = "";



  Future<void> pickImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      currentfilepath = pickedFile.path;
      notifyListeners();
    }
  }

  // Load profile data
  void LoadProfile() async{
    Map<String, dynamic>? profileData = await _loadProfileRepository.loadProfile();

    if (profileData != null) {
      name = profileData['Name'] ?? "Name";
      role = profileData['Role'] ?? "Role";
      currentfilepath = profileData['ProfileUrl'] ?? "ProfileUrl";
      print('Profile Data: $profileData');
      notifyListeners();
    } else {
      print('Profile Data is null');
    }
  }

}