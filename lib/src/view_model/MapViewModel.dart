import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
  MaplibreMapController? mapController;
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> mapLocations = [];

  Future<void> requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      lat = 14.5995;  // Example: Manila, Philippines
      long = 120.9842;
      notifyListeners();

      Position? position = await GeoUtils().getLocation();
      if (position != null) {
        lat = position.latitude;
        long = position.longitude;
      }

      notifyListeners();
    } else {
      ToastComponent().showMessage(Colors.red, 'Location permissions are denied.');
      notifyListeners();
    }
  }

  // This is the search locatons function
  Future<void> searchLocation(String query) async {
    try {
      final results = await _openStreetMapService.fetchOpenStreetMapData(query);

      if (results.isEmpty) {
        print('No results found.');
      } else {
        print('Results found: $results');
      }
      searchResults = results;
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Load custom marker image
  Future<void> loadMarkerImage() async {
    ByteData data = await rootBundle.load('assets/icon/location.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker", bytes);
    notifyListeners();
  }

  Future<void> loadMarkerClinic() async {
    ByteData data = await rootBundle.load('assets/images/hospital.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker", bytes);
    notifyListeners();
  }

  Future<void> loadMarkerShelter() async {
    ByteData data = await rootBundle.load('assets/images/shelter.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker", bytes);
    notifyListeners();
  }

  // Add marker to map
  Future<void> addPin(LatLng position) async {
    if (mapController != null) {

      // add await loadMarkerImage();
      await loadMarkerImage();
      print('Adding pin at: ${position.latitude}, ${position.longitude}');
      mapController!.clearSymbols();
      mapController!.addSymbol(SymbolOptions(
        geometry: position,
        iconImage: "custom_marker",
        iconSize: 2.0,
      ));
      notifyListeners();
    }
  }

  // Add marker to map for clinic and shelter
  Future<void> addPinForEstablisment(LatLng position, Map<String, dynamic> establishment) async {
    if (mapController != null) {

      // add await loadMarkerImage();
      await loadMarkerImage();
      print('Adding pin at: ${position.latitude}, ${position.longitude}');
      mapController!.clearSymbols();
      mapController!.addSymbol(SymbolOptions(
        geometry: position,
        iconImage: "custom_marker",
        iconSize: 2.0,
      ));
      notifyListeners();
    }
  }


  // Remove all markers from map
  void removePins() {
    if (mapController != null) {
      mapController!.clearSymbols();
      notifyListeners();
    }
  }
}