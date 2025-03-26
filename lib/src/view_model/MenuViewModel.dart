import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/respository/LocationRespository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../respository/LoadProfileRespository.dart';
import '../utils/GeoUtils.dart';

class MenuViewModel extends ChangeNotifier {
  final Loadprofilerespository _loadProfileRepository = LoadProfileImpl();
  final Locationrespository locationRepository = LocationrespositoryImpl();
  final ImagePicker imagePicker = ImagePicker();
  String currentfilepath = '';
  String name = "";
  String role = "";
  String email = "";
  bool isLocationEnabled = false;
  bool isRequesting = false;

  double lat = 0.0;  // Example: Manila, Philippines
  double long = 0.0;

  MenuViewModel() {
    requestPermissions();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      currentfilepath = pickedFile.path;
      notifyListeners();
    }
  }

  // Load profile data
  Future<void> loadProfile() async {
    _loadProfileRepository.loadProfile().listen((profileData) {
      if (profileData != null) {
        name = profileData['Name'] ?? "Name";
        role = profileData['Role'] ?? "Role";
        currentfilepath = profileData['ProfileUrl'] ?? "ProfileUrl";
        email = profileData['Email'] ?? "Email";
        print('Profile Data: $profileData');
        notifyListeners();
      } else {
        print('Profile Data is null');
      }
    });

    isLocationEnabled = await locationRepository.checkIfUserPinExists();

    if (!isLocationEnabled) {
      ToastComponent().showMessage(Colors.red, 'User pin does not exist');
      isLocationEnabled = false;
    } else {
      ToastComponent().showMessage(Colors.red, 'User pin already exists');
      isLocationEnabled = true;
    }
  }

  // get permissions
  Future<void> requestPermissions() async {
    Position? position = await GeoUtils().getLocation();
    if (position != null) {
      lat = position.latitude;
      long = position.longitude;
      isRequesting = true;
    } else {
      isRequesting = false;
      ToastComponent().showMessage(Colors.red, 'Failed to get location.');
    }
    notifyListeners();
  }

  Future<void> pinRescue() async {
    isLocationEnabled = await locationRepository.checkIfUserPinExists();
    if (isRequesting) {
      if (!isLocationEnabled) {
        locationRepository.pinRescue(lat, long);
        ToastComponent().showMessage(Colors.red, 'User pin created');
        isLocationEnabled = true;
      } else {
        ToastComponent().showMessage(Colors.red, 'User pin already exists');
      }
    } else {
      ToastComponent().showMessage(Colors.red, 'Location permissions are denied. Please enable location permissions.');
      requestPermissions();
    }
    notifyListeners();
  }

  // Unpin location
  Future<void> unpinRescue() async {
    isLocationEnabled = await locationRepository.checkIfUserPinExists();
    if (isLocationEnabled) {
      locationRepository.unpinRescue();
      ToastComponent().showMessage(Colors.red, 'User pin removed');
      isLocationEnabled = false;
    } else {
      ToastComponent().showMessage(Colors.red, 'User pin does not exist');
    }
    notifyListeners();
  }


}