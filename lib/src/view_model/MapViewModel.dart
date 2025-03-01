import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/respository/GenerateEstablismentRepository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import '../model/EstablishmentModel.dart';

class MapViewModel extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  final GenerateEstablismentRepository _generateEstablismentRepository = GenerateEstablismentRepositoryImpl();
  MaplibreMapController? mapController;
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> mapLocations = [];
  List<EstablishmentModel> establishments = [];
  bool _isLoadingMarkers = false;

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

  Future<void> loadMarkerImage() async {
    ByteData data = await rootBundle.load('assets/icon/location.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker", bytes);
    notifyListeners();
  }

  Future<void> loadMarkerClinic() async {
    ByteData data = await rootBundle.load('assets/images/hospital.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker_clinic", bytes);
    notifyListeners();
  }

  Future<void> loadMarkerShelter() async {
    ByteData data = await rootBundle.load('assets/images/shelter.png');
    Uint8List bytes = data.buffer.asUint8List();
    await mapController?.addImage("custom_marker_shelter", bytes);
    notifyListeners();
  }

  Future<void> addPin(LatLng position) async {
    if (mapController != null) {
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

  Future<void> fetchEstablishments() async {
    _generateEstablismentRepository.getEstablisment().listen((data) async {
      establishments = await compute(parseEstablishments, data.map((e) => e.toJson()).toList());
      addEstablishmentPins();
    });
  }

  static List<EstablishmentModel> parseEstablishments(List<Map<String, dynamic>> data) {
    return data.map((e) => EstablishmentModel.fromJson(e)).toList();
  }

  Future<void> addEstablishmentPins() async {
    if (mapController != null && !_isLoadingMarkers) {
      _isLoadingMarkers = true;
      for (var establishment in establishments) {
        if (establishment.establishmentType.toLowerCase() == 'clinic') {
          await loadMarkerClinic();
          mapController!.addSymbol(SymbolOptions(
            geometry: LatLng(establishment.establishmentLat, establishment.establishmentLong),
            iconImage: "custom_marker_clinic",
            iconSize: 1.0,
          ));
        } else if (establishment.establishmentType.toLowerCase() == 'shelter') {
          await loadMarkerShelter();
          mapController!.addSymbol(SymbolOptions(
            geometry: LatLng(establishment.establishmentLat, establishment.establishmentLong),
            iconImage: "custom_marker_shelter",
            iconSize: 1.0,
          ));
        }
      }
      _isLoadingMarkers = false;
      notifyListeners();
    }
  }

  void removePins() {
    if (mapController != null) {
      mapController!.clearSymbols();
      notifyListeners();
    }
  }
}