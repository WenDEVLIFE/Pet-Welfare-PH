import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../respository/LoadProfileRespository.dart';

class MapViewModel extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  final SessionManager _sessionManager = SessionManager();
  final Loadprofilerespository _loadProfileRepository = LoadProfileImpl();
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  List<Map<String, dynamic>> searchResults = [];

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

  Future<void> getLocation() async {
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

  Future<void> searchLocation(String query) async {
    try {
      final results = await _openStreetMapService.fetchOpenStreetMapData(query);

      if (results.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'No results found.');
      } else {
        ToastComponent().showMessage(Colors.green, 'Results found.');
      }
      searchResults = results;
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}