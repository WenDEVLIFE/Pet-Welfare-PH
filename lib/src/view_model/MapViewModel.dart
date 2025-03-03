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
  final GenerateEstablishmentRepository _generateEstablismentRepository = GenerateEstablishmentRepositoryImpl();
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

  Future<void> preloadMarkerImages() async {
    if (mapController == null) return;

    ByteData clinicData = await rootBundle.load('assets/images/hospital.png');
    Uint8List clinicBytes = clinicData.buffer.asUint8List();
    await mapController!.addImage("custom_marker_clinic", clinicBytes);

    ByteData shelterData = await rootBundle.load('assets/images/shelter.png');
    Uint8List shelterBytes = shelterData.buffer.asUint8List();
    await mapController!.addImage("custom_marker_shelter", shelterBytes);
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
    print("Fetching establishments...");
    _generateEstablismentRepository.getEstablishment().asyncMap((data) async {
      final jsonData = data.map((e) => e.toJson()).toList();
      establishments = await compute(parseEstablishments, jsonData);
      await addEstablishmentPins();
      print("Establishment pins added.");
    }).listen((_) {});
  }

  @override
  Future<void> initializeLoads() async {
    await preloadMarkerImages();
    await addEstablishmentPins();
  }


  static List<EstablishmentModel> parseEstablishments(List<Map<String, dynamic>> data) {
    return data.map((e) => EstablishmentModel.fromJson(e)).toList();
  }

  Future<void> addEstablishmentPins() async {
    if (mapController == null || _isLoadingMarkers || establishments.isEmpty) return;

    _isLoadingMarkers = true;
    List<SymbolOptions> symbols = [];

    for (var establishment in establishments) {
      String markerType = establishment.establishmentType.toLowerCase() == 'clinic'
          ? "custom_marker_clinic"
          : "custom_marker_shelter";

      preloadMarkerImages();

      symbols.add(SymbolOptions(
        geometry: LatLng(establishment.establishmentLat, establishment.establishmentLong),
        iconImage: markerType,
        iconSize: 1.0,
        textField: establishment.establishmentName,  // Adding a label for identification
        textOffset: const Offset(0, 1.5),  // Adjust the offset to place the text below the icon
      ));
    }

    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }

    _isLoadingMarkers = false;

    // Set up the click listener
    mapController!.onSymbolTapped.add((Symbol symbol) {
      String name = symbol.options.textField ?? 'Unknown';

        for (var establishment in establishments) {
          if (establishment.establishmentName == name) {
            ToastComponent().showMessage(Colors.green, 'Establishment: ${establishment.establishmentName}');
          }
        }
    });
  }

  void removePins() {
    if (mapController != null) {
      mapController!.clearSymbols();
      initializeLoads();
      notifyListeners();
    }
  }

}