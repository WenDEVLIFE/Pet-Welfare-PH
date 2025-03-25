import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/GenerateEstablismentRepository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import '../modal/EstablishmentModal.dart';
import '../model/EstablishmentModel.dart';
import '../respository/PostRepository.dart';

class MapViewModel extends ChangeNotifier {
  double lat = 14.5995;  // Example: Manila, Philippines
  double long = 120.9842;
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  final GenerateEstablishmentRepository _generateEstablismentRepository = GenerateEstablishmentRepositoryImpl();
  PostRepository postRepository = PostRepositoryImpl();
  MaplibreMapController? mapController;
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> mapLocations = [];
  List<EstablishmentModel> establishments = [];
  List<PostModel> lostpets = [];
  List<PostModel> foundpets = [];
  Stream<List<PostModel>>? foundPetsStream;
  Stream<List<PostModel>>? lostPetsStream;
  List<SymbolOptions> symbols = [];
  bool _isLoadingMarkers = false;

  MapViewModel() {
    requestPermissions();
  }

  // get permissions
  Future<void> requestPermissions() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Position? position = await GeoUtils().getLocation();
        if (position != null) {
          lat = position.latitude;
          long = position.longitude;
        }
        notifyListeners();
      });
    } else {
      ToastComponent().showMessage(Colors.red, 'Location permissions are denied.');
      notifyListeners();
    }
  }

  // search locations
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

    ByteData establismentData = await rootBundle.load('assets/images/company.png');
    Uint8List establistmentBytes = establismentData.buffer.asUint8List();
    await mapController!.addImage("custom_marker_establishment", establistmentBytes);

    ByteData lostData = await rootBundle.load('assets/images/lost.png');
    Uint8List lostBytes = lostData.buffer.asUint8List();
    await mapController!.addImage("custom_marker_lost", lostBytes);

    ByteData foundData = await rootBundle.load('assets/images/found.png');
    Uint8List foundBytes = foundData.buffer.asUint8List();
    await mapController!.addImage("custom_marker_found", foundBytes);
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

  Future<void> initializeLoads() async {
    await preloadMarkerImages();
    await fetchEstablishments();
    await fetchLostAndFoundPets();
    await fetchFoundPets();
  }

  static List<EstablishmentModel> parseEstablishments(List<Map<String, dynamic>> data) {
    return data.map((e) => EstablishmentModel.fromJson(e)).toList();
  }

  Future<void> addEstablishmentPins() async {
    if (mapController == null || _isLoadingMarkers || establishments.isEmpty) return;

    _isLoadingMarkers = true;

    for (var establishment in establishments) {
      String markerType;
      if (establishment.establishmentType.toLowerCase() == 'clinic') {
        markerType = "custom_marker_clinic";
      } else if (establishment.establishmentType.toLowerCase() == 'shelter') {
        markerType = "custom_marker_shelter";
      } else {
        markerType = "custom_marker_establishment";
      }

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
  }

  Future<void> addLostAndFoundPetPins() async {
    if (mapController == null || _isLoadingMarkers || lostpets.isEmpty) return;

    _isLoadingMarkers = true;

    for (var pet in lostpets) {
      symbols.add(SymbolOptions(
        geometry: LatLng(pet.lat, pet.long),
        iconImage: "custom_marker_lost",
        iconSize: 1.0,
        textField: 'Lost pet spotted',  // Adding a label for identification
        textOffset: const Offset(0, 1.5),  // Adjust the offset to place the text below the icon
      ));
    }

    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }

    _isLoadingMarkers = false;
  }

  Future<void> addPetAdoptionPins() async {
    if (mapController == null || _isLoadingMarkers || foundpets.isEmpty) return;

    _isLoadingMarkers = true;

    for (var post in foundpets) {
      symbols.add(SymbolOptions(
        geometry: LatLng(post.lat, post.long),
        iconImage: "custom_marker_found",
        iconSize: 1.0,
        textField: 'Found pet spotted',  // Adding a label for identification
        textOffset: const Offset(0, 1.5),  // Adjust the offset to place the text below the icon
      ));
    }

    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }

    _isLoadingMarkers = false;
  }

  void initializeClickMarkers(BuildContext context) {
    // Set up the click listener
    mapController!.onSymbolTapped.add((Symbol symbol) {
      String name = symbol.options.textField ?? 'Unknown';

      for (var establishment in establishments) {
        if (establishment.establishmentName == name) {
          ToastComponent().showMessage(Colors.green, 'Establishment: ${establishment.establishmentName}');

          var establismentInfo = {
            'establishmentName': establishment.establishmentName,
            'establishmentType': establishment.establishmentType,
            'establishmentAddress': establishment.establishmentAddress,
            'establishmentContact': establishment.establishmentPhoneNumber,
            'establishmentEmail': establishment.establishmentEmail,
            'establishmentLat': establishment.establishmentLat,
            'establishmentLong': establishment.establishmentLong,
            'establishmentId': establishment.id,
            'establishmentImage': establishment.establishmentPicture,
            'establishmentDescription': establishment.establishmentDescription,
            'establishmentOwnerID': establishment.establishmentOwnerID,
          };
          EstablismentModal().ShowEstablismentModal(context, establismentInfo, this);
        }
      }

      for (var pet in lostpets) {
        if (pet.petName == name) {
          ToastComponent().showMessage(Colors.green, 'Lost and Found Pet: ${pet.petName}');

          var petInfo = {
            'petName': pet.petName,
            'petType': pet.petType,
            'petBreed': pet.petBreed,
            'petGender': pet.petGender,
            'petAge': pet.petAge,
            'petColor': pet.petColor,
            'petAddress': pet.petAddress,
            'regProCiBag': pet.regProCiBag,
            'date': pet.date,
            'lat': pet.lat,
            'long': pet.long,
          };
          // Show pet info modal or any other UI component
        }
      }

      for (var post in foundpets) {
        if (post.petName == name) {
          ToastComponent().showMessage(Colors.green, 'Pet Adoption: ${post.petName}');

          var postInfo = {
            'petName': post.petName,
            'petType': post.petType,
            'petBreed': post.petBreed,
            'petGender': post.petGender,
            'petAge': post.petAge,
            'petColor': post.petColor,
            'petAddress': post.petAddress,
            'regProCiBag': post.regProCiBag,
            'date': post.date,
            'lat': post.lat,
            'long': post.long,
          };
          // Show post info modal or any other UI component
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

  Future<void> fetchLostAndFoundPets() async {
    lostPetsStream = postRepository.getMissingPosts();
    lostPetsStream!.listen((data) {
      lostpets = data;
      addLostAndFoundPetPins();
      notifyListeners();
    });
  }

  Future<void> fetchFoundPets() async {
    foundPetsStream = postRepository.getFoundPost();
    foundPetsStream!.listen((data) {
      foundpets = data;
      addPetAdoptionPins();
      notifyListeners();
    });
  }
}