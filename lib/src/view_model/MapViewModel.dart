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
    // Set a default location while fetching
    lat = 14.5995;  // Example: Manila, Philippines
    long = 120.9842;
    notifyListeners();

    Position? position = await GeoUtils().getLocation();
    if (position != null) {
      lat = position.latitude;
      long = position.longitude;
    }
    notifyListeners();
  }

  // Load the role

}