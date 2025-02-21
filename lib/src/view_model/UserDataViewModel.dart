import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/respository/LoadProfileRespository.dart';
import 'package:pet_welfrare_ph/src/respository/UpdateProfileRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import '../utils/SessionManager.dart';

class UserDataViewModel extends ChangeNotifier {
  final List<String> idType1 = [
    'Passport', 'Driver\'s License', 'SSS ID', 'UMID', 'Voter\'s ID', 'Postal ID', 'PRC ID',
    'OFW ID', 'Senior Citizen ID', 'PWD ID', 'Student ID', 'Company ID', 'Police Clearance',
    'NBI Clearance', 'Barangay Clearance', 'Health Card', 'PhilHealth ID', 'TIN ID', 'GSIS ID',
    'Pag-IBIG ID', 'DFA ID', 'National ID',
  ];

  final ImagePicker imagePicker = ImagePicker();
  String frontImagePath = '';
  String backImagePath = '';
  String selectedProfilePath = '';

  String name = '';
  String email = '';
  String idType = '';
  String profilepath = '';
  String idfrontpath = '';
  String idbackpath = '';
  String role = '';
  String address = '';
  String id = '';
  String status = '';
  String selectedIdType = '';
  bool isImage = false;

  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final UpdateProfileRepository _updateProfileRepository = UpdateProfileImpl();
  final sessionManager = SessionManager();

  // This is load information method
  Future<void> loadInformation() async {
    _loadprofilerespository.loadProfile1().listen((userData) {
      if (userData != null) {
        name = userData?['name'] ?? '';
        email = userData?['email'] ?? '';
        idType = userData?['idType'] ?? '';
        profilepath = userData?['profilepath'] ?? '';
        idfrontpath = userData?['idfrontpath'] ?? '';
        idbackpath = userData?['idbackpath'] ?? '';
        role = userData?['role'] ?? '';
        address = userData?['address'] ?? '';
        status = userData?['status'] ?? '';
        selectedIdType = idType.isNotEmpty ? idType : (idType1.isNotEmpty ? idType1.first : '');
        notifyListeners();
      }
    });

  }

  // This is pick image method
  Future<void> pickImage(bool isFront) async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isFront) {
        frontImagePath = pickedFile.path;
      } else {
        backImagePath = pickedFile.path;
      }
      isImage = true;
      notifyListeners();
    }
  }

  // This is pick select profile image method
  Future<void> pickSelectProfileImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedProfilePath = pickedFile.path;
      notifyListeners();
    }
  }

  // This is load selected id type method
  void loadSelectedIDType() {
    selectedIdType = idType;
    notifyListeners();
  }

  // This is update id type method
  void updateIdType(String newValue) {
    selectedIdType = newValue;
    notifyListeners();
  }

  // This is update information method
  void updateProfile(BuildContext context) {
    if (frontImagePath.isNotEmpty && backImagePath.isNotEmpty) {
      var userData = {
        'idType': selectedIdType,
        'idfrontpath': frontImagePath,
        'idbackpath': backImagePath,
      };

      _updateProfileRepository.updateProfile(userData, isImage, context);
    } else {
      ToastComponent().showMessage(Colors.red, 'Please upload both front and back of your ID');
    }
  }

  void updateProfileData(BuildContext context) {
    if (selectedProfilePath.isNotEmpty) {
      var userData = {
        'profilepath': selectedProfilePath,
      };

      _updateProfileRepository.updateProfile1(userData, isImage, context);
    } else {
      ToastComponent().showMessage(Colors.red, 'Please upload your profile picture');
    }
  }
}