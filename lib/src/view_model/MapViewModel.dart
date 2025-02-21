import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

class MapViewModel extends ChangeNotifier {

  double lat = 0.0;
  double long = 0.0;

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

      ToastComponent().showMessage(Colors.green, 'Location: $lat, $long');
      notifyListeners();
    }
  }

}