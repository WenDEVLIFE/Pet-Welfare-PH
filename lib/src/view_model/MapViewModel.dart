import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../respository/LoadProfileRespository.dart';

class MapViewModel extends ChangeNotifier {

  double lat = 0.0;
  double long = 0.0;
  String role ='';

  final SessionManager _sessionManager = SessionManager();
  final Loadprofilerespository _loadProfileRepository = LoadProfileImpl();
  // Get the permissions
  Future<void> requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      getLocation();
      notifyListeners();
    } else {
      ToastComponent().showMessage(Colors.red, 'Location permissions are denied.');
      notifyListeners();
    }
  }

  // Get the locations
  Future<void> getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position? position = await GeoUtils().getLocation();
    if (position != null) {

      long = position.longitude;
      lat = position.latitude;

     // ToastComponent().showMessage(Colors.green, 'Location: $lat, $long');
      notifyListeners();
    }
  }

  // Load the role
  void loadRole() {
    _loadProfileRepository.loadProfile().listen((profileData) {
      if (profileData != null) {
        role = profileData['Role'] ?? "Role";
        print('Profile Data: $profileData');
        notifyListeners();
      } else {
        print('Profile Data is null');
      }
    });
  }
}