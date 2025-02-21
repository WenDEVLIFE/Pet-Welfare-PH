import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

class GeoUtils {
  Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
     ToastComponent().showMessage(Colors.red, 'Location services are disabled.');
      return null;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastComponent().showMessage(Colors.red, 'Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ToastComponent().showMessage(Colors.red, 'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}