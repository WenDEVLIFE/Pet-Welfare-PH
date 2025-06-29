import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/modal/PetModal.dart';
import 'package:pet_welfrare_ph/src/modal/RescueModal.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/model/RescueModel.dart';
import 'package:pet_welfrare_ph/src/respository/GenerateEstablismentRepository.dart';
import 'package:pet_welfrare_ph/src/respository/LocationRespository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/GeoUtils.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../modal/EstablishmentModal.dart';
import '../model/EstablishmentModel.dart';
import '../respository/PostRepository.dart';

class MapViewModel extends ChangeNotifier {
  MaplibreMapController? mapController;

  double lat = 14.5995;
  double long = 120.9842;
  double radiusInKm = 0.0;

  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  final GenerateEstablishmentRepository _generateEstablismentRepository = GenerateEstablishmentRepositoryImpl();
  final Locationrespository locationRepository = LocationrespositoryImpl();
  PostRepository postRepository = PostRepositoryImpl();

  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> mapLocations = [];
  List<SymbolOptions> symbols = [];
  List<EstablishmentModel> establishments = [];
  List<PostModel> lostpets = [];
  List<PostModel> foundpets = [];
  List<RescueModel> rescue = [];

  Stream<List<EstablishmentModel>>? establishmentsStream;
  Stream<List<PostModel>>? foundPetsStream;
  Stream<List<PostModel>>? lostPetsStream;
  Stream <List<RescueModel>>? rescueStream;


  bool _isLoadingMarkers = false;
  bool showDropdown = false;

  String? selectedRadius;
  String? selectLocationType;

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Circle? _circle;

  MapViewModel() {
    developer.log('Requesting permissions...');
    requestPermissions();
    developer.log('Permissions requested.');
    initializeLoads();
  }

  // get permissions
 Future <void> requestPermissions() async  {
   Position? position = await GeoUtils().getLocation();
   if (position != null) {
     lat = position.latitude;
     long = position.longitude;
     CameraPosition initialPosition = CameraPosition(target: LatLng(lat, long), zoom: 14);
      mapController!.moveCamera(CameraUpdate.newCameraPosition(initialPosition));
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

  // get preloaded marker images
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

  // load and cache image
  Future<void> _loadAndCacheImage(String assetPath, String imageName) async {
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();
    await mapController!.addImage(imageName, bytes);
  }

  // add pin
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

  // get current location
  Future<void> initializeLoads() async {
    await Future.wait([
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

    notifyListeners();
  }

  // get establishments
  static List<EstablishmentModel> parseEstablishments(List<Map<String, dynamic>> data) {
    return data.map((e) => EstablishmentModel.fromJson(e)).toList();
  }

  // add establishments pins
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

  // clear search
  void clearSearch() {
    searchController.clear();
    showDropdown = false;
    notifyListeners();
  }

  // add lost and found pet pins
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

  // add pet adoption pins
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

  // add rescue pins
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

  // added click markers
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
      if (symbol.options.iconImage == "custom_marker_lost") {
        for (var pet in lostpets) {
          if (name == '${pet.category} spotted') {
            ToastComponent().showMessage(Colors.green, 'Lost and Found Pet: ${pet.petName}');

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
              'category': pet.category,
              'imageUrls': pet.imageUrls,
              'postOwnerId': pet.postOwnerId,
              'status': pet.Status,
            };
            // Show pet info modal or any other UI component
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
      }

      // Check for found pet markers
      if (symbol.options.iconImage == "custom_marker_found") {
        for (var pet in foundpets) {
          if (name == '${pet.category} spotted') {
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
              'category': pet.category,
              'imageUrls': pet.imageUrls,
              'postOwnerId': pet.postOwnerId,
              'status': pet.Status,
            };
            // Show found pet modal
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
      }

      // Check for rescue markers
      if (symbol.options.iconImage == "custom_marker_rescuer") {
        for (var res in rescue) {
          if (name == '${res.role} spotted') {
            ToastComponent().showMessage(Colors.green, 'Rescuer: ${res.name}');
            var rescueInfo = {
              'name': res.name,
              'lat': res.latitude.toString(),
              'long': res.longtitude.toString(),
              'rescueId': res.id,
              'rescueImage': res.profileUrl,
            };
            // Show post info modal or any other UI component
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return RescueModal(petrescuer: rescueInfo);
              },
            );

            return; // Stop further checks
          }
        }
      }
    });
  }

  // remove pins
  void removePins() {
    if (mapController != null) {
      mapController!.clearSymbols();
      initializeLoads();
      notifyListeners();
    }
  }

  // fetch lost and found pets
  Future<void> fetchLostAndFoundPets() async {
    lostPetsStream = postRepository.getMissingPosts();
    lostPetsStream!.listen((data) {
      lostpets = data;
      addLostAndFoundPetPins();
      notifyListeners();
    });
  }

  // fetch found pets
  Future<void> fetchFoundPets() async {
    foundPetsStream = postRepository.getFoundPost();
    foundPetsStream!.listen((data) {
      foundpets = data;
      addPetAdoptionPins();
      notifyListeners();
    });
  }

  // fetch establishments
  Future<void> fetchEstablishments() async {
    print("Fetching establishments...");
    establishmentsStream = _generateEstablismentRepository.getEstablishment();
    establishmentsStream!.listen((data) {
      establishments = data;
      addEstablishmentPins();
      notifyListeners();
    });
  }

  // fetch rescue
  Future<void> fetchRescue() async {
    print("Fetching rescue...");
    rescueStream = locationRepository.getRescueData();
    rescueStream!.listen((data) {
      rescue = data;
      addRescuePins();
      notifyListeners();
    });
  }

  // on camera idle
  void onCameraIdle() {
    if (mapController != null) {
      addEstablishmentPins();
      addLostAndFoundPetPins();
      addPetAdoptionPins();
      addRescuePins();
      notifyListeners();
    }
  }

  // refresh markers
  Future<void> refreshMarkers() async {
    if (mapController != null) {
      mapController!.clearSymbols();
      await initializeLoads();
      notifyListeners();
    }
  }

  // set search text
  Future <void> setSearchText()async {
    showDropdown = searchController.text.isNotEmpty;
    notifyListeners();
  }

// set selected radius
  void setSelectedRadius(String? value) {
    selectedRadius = value;
    notifyListeners();
  }

  // set selected location
  void setSelectLocation(String? value) {
    selectLocationType = value;
    notifyListeners();
  }

  void initializeNearbyData() {
    if (selectLocationType == null) {
      ToastComponent().showMessage(Colors.red, 'Please select a location type.');
      return;
    }

    switch (selectLocationType!.toLowerCase()) {
      case 'search all locations':
        initializeNearby();
        break;
      case 'establishment only':
        initializeEstablishments();
        break;
      case 'missing pets only':
        initializeLostPets();
        break;
      case 'found pets only':
        initializeFoundPets();
        break;
      case 'rescuer only':
        initializeRescuers();
        break;
      default:
        ToastComponent().showMessage(Colors.red, 'Invalid location type selected.');
    }
  }

  Future<void> initializeNearby() async {
    try {
      if (mapController == null) return;

      Position? position = await GeoUtils().getLocation();
      if (position == null) {
        ToastComponent().showMessage(Colors.red, 'Unable to get current location.');
        return;
      }

      setRadius();
      lat = position.latitude;
      long = position.longitude;

      // Clear existing symbols
      mapController!.clearSymbols();
      symbols.clear();

      // Fetch and add symbols for all types
      await Future.wait([
        nearbyEstablishments(),
        nearbyLostPets(),
        nearbyFoundPets(),
        nearbyRescuers(),
      ]);

      if (symbols.isNotEmpty) {
        await mapController!.addSymbols(symbols);
        await mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setRadius() {
    if (selectedRadius == '1km to 5km') {
      radiusInKm = 5.0;
    } else if (selectedRadius == '5km to 10km') {
      radiusInKm = 10.0;
    } else if (selectedRadius == '10km to 20km') {
      radiusInKm = 20.0;
    }
  }

  Future<void> nearbyEstablishments() async {
    List<EstablishmentModel> nearbyEstablishments = await fetchNearbyEstablishments(lat, long);
    for (var establishment in nearbyEstablishments) {
      symbols.add(SymbolOptions(
        geometry: LatLng(establishment.establishmentLat, establishment.establishmentLong),
        iconImage: establishment.establishmentType.toLowerCase() == 'clinic'
            ? "custom_marker_clinic"
            : establishment.establishmentType.toLowerCase() == 'shelter'
            ? "custom_marker_shelter"
            : "custom_marker_establishment",
        iconSize: 1.0,
        textField: establishment.establishmentName,
        textOffset: const Offset(0, 1.5),
      ));
    }
  }

  Future<void> nearbyLostPets() async {
    List<PostModel> nearbyLostPets = await fetchNearbyLostPets(lat, long);
    for (var pet in nearbyLostPets) {
      symbols.add(SymbolOptions(
        geometry: LatLng(pet.lat, pet.long),
        iconImage: "custom_marker_lost",
        iconSize: 1.5,
        textField: '${pet.category} spotted',
        textOffset: const Offset(0, 1.5),
      ));
    }
  }

  Future<void> nearbyFoundPets() async {
    List<PostModel> nearbyFoundPets = await fetchNearbyFoundPets(lat, long);
    for (var pet in nearbyFoundPets) {
      symbols.add(SymbolOptions(
        geometry: LatLng(pet.lat, pet.long),
        iconImage: "custom_marker_found",
        iconSize: 1.5,
        textField: '${pet.category} spotted',
        textOffset: const Offset(0, 1.5),
      ));
    }
  }

  Future<void> nearbyRescuers() async {
    List<RescueModel> nearbyRescuers = await fetchNearbyRescuers(lat, long);
    for (var rescuer in nearbyRescuers) {
      symbols.add(SymbolOptions(
        geometry: LatLng(rescuer.latitude, rescuer.longtitude),
        iconImage: "custom_marker_rescuer",
        iconSize: 1.5,
        textField: '${rescuer.role} spotted',
        textOffset: const Offset(0, 1.5),
      ));
    }
  }


  // get the nearby establishments
  Future<List<EstablishmentModel>> fetchNearbyEstablishments(double lat, double long) async {
    try {
      // Replace with actual API call to fetch nearby establishments
      final response = await _generateEstablismentRepository.getNearbyEstablishments(lat, long, radiusInKm);
      return response;
    } catch (e) {
      developer.log('Error fetching nearby establishments: $e');
      return [];
    }


  }

  // get the nearby missing pets
  Future<List<PostModel>> fetchNearbyLostPets(double lat, double long) async {
    try {
      // Replace with actual API call to fetch nearby lost pets
      final response = await postRepository.getNearbyLostPets(lat, long,radiusInKm);
      return response;
    } catch (e) {
      developer.log('Error fetching nearby lost pets: $e');
      return [];
    }
  }

  // Fetch Found Pets
  Future<List<PostModel>> fetchNearbyFoundPets(double lat, double long) async {
    try {
      // Replace with actual API call to fetch nearby found pets
      final List<PostModel> response = await postRepository.getNearbyFoundPets(lat, long, radiusInKm);
      return response;
    } catch (e) {
      developer.log('Error fetching nearby found pets: $e');
      return [];
    }
  }

  // Fetch Rescuer
  Future<List<RescueModel>> fetchNearbyRescuers(double lat, double long) async {
    try {
      // Replace with actual API call to fetch nearby rescuers
      final response = await locationRepository.getNearbyRescuers(lat, long, radiusInKm);
      return response;
    } catch (e) {
      developer.log('Error fetching nearby rescuers: $e');
      return [];
    }
  }

  // initialize establishments
  void initializeEstablishments() async {
    if (mapController == null) return;

    mapController!.clearSymbols();
    symbols.clear();

    await nearbyEstablishments();
    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }
    notifyListeners();
  }

  // initialize lost pets
  void initializeLostPets() async {
    if (mapController == null) return;

    mapController!.clearSymbols();
    symbols.clear();

    await nearbyLostPets();
    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }
    notifyListeners();
  }

  // initialize found pets
  void initializeFoundPets() async {
    if (mapController == null) return;

    mapController!.clearSymbols();
    symbols.clear();

    await nearbyFoundPets();
    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }
    notifyListeners();
  }

  // initialize rescuers
  void initializeRescuers() async {
    if (mapController == null) return;

    mapController!.clearSymbols();
    symbols.clear();

    await nearbyRescuers();
    if (symbols.isNotEmpty) {
      await mapController!.addSymbols(symbols);
    }
    notifyListeners();
  }

  // Method to add a circle to the map
  Future<void> addCircle(LatLng position, double radius) async {
    if (mapController == null) return;

    _circle = await mapController!.addCircle(
      CircleOptions(
        geometry: position,
        circleRadius: radius,
        circleColor: "#0000FF", // Blue color
        circleOpacity: 0.5, // Semi-transparent
      ),
    );
    notifyListeners();
  }

  // Method to update the circle's radius
  Future<void> updateCircleRadius(double radius) async {
    if (_circle == null || mapController == null) return;

    mapController!.updateCircle(
      _circle!,
      CircleOptions(
        circleRadius: radius,
      ),
    );
    notifyListeners();
  }

  // Example method to initialize the circle with a default radius
  Future<void> initializeCircle() async {
    if (mapController == null) return;

    Position? position = await GeoUtils().getLocation();
    if (position != null) {
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      await addCircle(currentPosition, 1000); // Initial radius of 1000 meters
    }
  }

  // Example method to expand the circle radius
  Future<void> expandCircleRadius() async {
    if (_circle == null) return;

    double newRadius = _circle!.options.circleRadius! + 500; // Increase radius by 500 meters
    await updateCircleRadius(newRadius);
  }
}