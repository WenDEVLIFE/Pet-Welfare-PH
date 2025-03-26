import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_welfrare_ph/src/modal/PetModal.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/model/RescueModel.dart';
import 'package:pet_welfrare_ph/src/respository/GenerateEstablismentRepository.dart';
import 'package:pet_welfrare_ph/src/respository/LocationRespository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import '../modal/EstablishmentModal.dart';
import '../model/EstablishmentModel.dart';
import '../respository/PostRepository.dart';
import 'package:async/async.dart';

class MapViewModel extends ChangeNotifier {
  double lat = 14.5995;  // Example: Manila, Philippines
  double long = 120.9842;
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  final GenerateEstablishmentRepository _generateEstablismentRepository = GenerateEstablishmentRepositoryImpl();
  final Locationrespository locationRepository = LocationrespositoryImpl();
  PostRepository postRepository = PostRepositoryImpl();
  MaplibreMapController? mapController;
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> mapLocations = [];
  List<EstablishmentModel> establishments = [];
  List<PostModel> lostpets = [];
  List<PostModel> foundpets = [];
  List<RescueModel> rescue = [];
  Stream<List<EstablishmentModel>>? establishmentsStream;
  Stream<List<PostModel>>? foundPetsStream;
  Stream<List<PostModel>>? lostPetsStream;
  Stream <List<RescueModel>>? rescueStream;
  List<SymbolOptions> symbols = [];
  bool _isLoadingMarkers = false;

  MapViewModel() {
    initializeLoads();
  }

  // get permissions
 Future <void> requestPermissions() async  {
   Position? position = await GeoUtils().getLocation();
   if (position != null) {
     lat = position.latitude;
     long = position.longitude;
     notifyListeners();
   } else{
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
    await _loadAndCacheImage('assets/icon/location.png', 'custom_marker');
    notifyListeners();
  }

  Future<void> preloadMarkerImages() async {
    if (mapController == null) return;

    await _loadAndCacheImage('assets/images/hospital.png', 'custom_marker_clinic');
    await _loadAndCacheImage('assets/images/shelter.png', 'custom_marker_shelter');
    await _loadAndCacheImage('assets/images/company.png', 'custom_marker_establishment');
    await _loadAndCacheImage('assets/images/lost.png', 'custom_marker_lost');
    await _loadAndCacheImage('assets/images/found.png', 'custom_marker_found');
    await _loadAndCacheImage('assets/images/rescue.png', 'custom_marker_rescuer');

    notifyListeners();
  }

  Future<void> _loadAndCacheImage(String assetPath, String imageName) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();
    await mapController!.addImage(imageName, bytes);
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

  Future<void> initializeLoads() async {
    await Future.wait([
          () async {
        developer.log('Requesting permissions...');
        await requestPermissions();
        developer.log('Permissions requested.');
      }(),
          () async {
        developer.log('Preloading marker images...');
        await preloadMarkerImages();
        developer.log('Marker images preloaded.');
      }(),
          () async {
        developer.log('Fetching establishments...');
        await fetchEstablishments();
        developer.log('Establishments fetched.');
      }(),
          () async {
        developer.log('Fetching lost and found pets...');
        await fetchLostAndFoundPets();
        developer.log('Lost and found pets fetched.');
      }(),
          () async {
        developer.log('Fetching found pets...');
        await fetchFoundPets();
        developer.log('Found pets fetched.');
      }(),
          () async {
        developer.log('Fetching rescue...');
        await fetchRescue();
        developer.log('Rescue fetched.');
      }(),
    ]);
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
        iconSize: 1.5,
        textField: '${pet.category} spotted',  // Adding a label for identification
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
        iconSize: 1.5,
        textField: '${post.category} spotted',  // Adding a label for identification
        textOffset: const Offset(0, 1.5),  // Adjust the offset to place the text below the icon
      ));
    }

    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }

    _isLoadingMarkers = false;
  }

  Future <void> addRescuePins()  async {
    if (mapController == null || _isLoadingMarkers || rescue.isEmpty) return;

    _isLoadingMarkers = true;

    for (var res in rescue) {
      symbols.add(SymbolOptions(
        geometry: LatLng(res.latitude, res.longtitude),
        iconImage: "custom_marker_rescuer",
        iconSize: 1.5,
        textField: '${res.role} spotted',  // Adding a label for identification
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

      // Check for establishment markers
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
          return; // Stop further checks
        }
      }

      // Check for lost pet markers
      for (var pet in lostpets) {
        if (symbol.options.iconImage == "custom_marker_lost" && pet.category.toLowerCase() == 'lost pets') {
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
            'postOwnerId': pet.postOwnerId,
            'status': pet.Status,
          };
          // Show pet info modal or any other UI component
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return PetModal(pet: petInfo);
            },
          );
          return; // Stop further checks
        }
      }

      // Check for found pet markers
      for (var pet in foundpets) {
        if (symbol.options.iconImage == "custom_marker_found" && pet.category.toLowerCase() == 'found pets') {
          ToastComponent().showMessage(Colors.green, 'Pet Found: ${pet.petName}');

          var postInfo = {
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
            'imageUrls': pet.imageUrls,
            'postOwnerId': pet.postOwnerId,
            'status': pet.Status,
          };
          // Show post info modal or any other UI component
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return PetModal(pet: postInfo);
            },
          );
          return; // Stop further checks
        }
      }

      // Check for rescue markers
      for (var res in rescue) {
        if (symbol.options.iconImage == "custom_marker_rescuer" && res.role.toLowerCase() == 'pet rescuer') {
          ToastComponent().showMessage(Colors.green, 'Rescuer: ${res.name}');
          var rescueInfo = {
            'name': res.name,
            'latitude': res.latitude,
            'longtitude': res.longtitude,
            'rescueId': res.id,
            'rescueImage': res.profileUrl,
          };
          // Show post info modal or any other UI component
          // TODO: Show rescue info modal

          return; // Stop further checks
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

  Future<void> fetchEstablishments() async {
    print("Fetching establishments...");
    establishmentsStream = _generateEstablismentRepository.getEstablishment();
    establishmentsStream!.listen((data) {
      establishments = data;
      addEstablishmentPins();
      notifyListeners();
    });
  }

  Future<void> fetchRescue() async {
    print("Fetching rescue...");
    rescueStream = locationRepository.getRescueData();
    rescueStream!.listen((data) {
      rescue = data;
      addRescuePins();
      notifyListeners();
    });
  }

  void onCameraIdle() {
    if (mapController != null) {
      addEstablishmentPins();
      addLostAndFoundPetPins();
      addPetAdoptionPins();
      addRescuePins();
      notifyListeners();
    }
  }
}