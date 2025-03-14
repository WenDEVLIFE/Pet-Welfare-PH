import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'dart:io';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:pet_welfrare_ph/src/model/RegionModel.dart';
import 'package:pet_welfrare_ph/src/model/ProvinceModel.dart';
import 'package:pet_welfrare_ph/src/model/CityModel.dart';
import 'package:pet_welfrare_ph/src/model/BarangayModel.dart';

import '../model/BreedModel.dart';
import '../services/PetAPI.dart';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController petName = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController provinceCityMunicipalityBarangayController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final List<File> _images = [];
  var collarList = ['Select a collar', 'With Collar', 'Without Collar'];
  // Add these fields to store the breeds
  List<String> petTypes = ['Cat', 'Dog'];
  String selectedPetType = 'Cat';
  List<Breed> catBreeds = [];
  List<Breed> dogBreeds = [];
  Breed? selectPedBreed;

  var chipLabels1 = [
    'Pet Appreciation',
    'Missing Pets',
    'Found Pets',
    'Find a Home: Rescue & Shelter',
    'Call for Aid',
    'Paw-some Experience',
    'Pet Adoption',
    'Protect Our Pets: Report Abuse',
    'Caring for Pets: Vet & Travel Insights',
    'Community Announcements'
  ];

  final PostRepository postRepository = PostRepositoryImpl();

  String selectedChip = 'Pet Appreciation';

  List<File> get images => _images;

  // Add these fields
  RegionModel? selectedRegion;
  ProvinceModel? selectedProvince;
  CityModel? selectedCity;
  BarangayModel? selectedBarangay;

  // This is for the dropdowns for lost and found pets
  List<RegionModel> regions = [];
  List<ProvinceModel> provinces = [];
  List<CityModel> cities = [];
  List<BarangayModel> barangays = [];
  bool isLoading = false;

  // This is for the maps selection
  LatLng? selectedLocation;
  bool _locationInitialized = false;
  double lat = 0.0;
  double long = 0.0;
  double newlat = 0.0;
  double newlong = 0.0;
  MaplibreMapController? mapController;
  List<Map<String, dynamic>> searchResults = [];

  // OpenStreetMapService
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();
  bool showDropdown = false;

  CreatePostViewModel() {
    loadUserLocation();
    fetchRegions();
    fetchCatBreeds(); // Fetch cat breeds
    fetchDogBreeds(); // Fetch dog breeds

    searchController.addListener(() {
      showDropdown = searchController.text.isNotEmpty;
    });
  }

  Future<void> loadUserLocation() async {
    await setInitialLocation();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _images.add(File(image.path));
      notifyListeners();
    }
  }

  void removeImage(File image) {
    _images.remove(image);
    notifyListeners();
  }

  void setSelectRole(String selectedValue) {
    selectedChip = selectedValue;
    notifyListeners();
  }

  void clearPost() {
    postController.clear();
    _images.clear();
    selectedChip = 'Pet Appreciation';
    notifyListeners();
  }

  Future<void> PostNow(BuildContext context) async {
    if (selectedChip == 'Pet Appreciation') {
      if (postController.text.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
      } else if (_images.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'Please select an image');
      } else {
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Posting...');
        try {
          await postRepository.uploadPost(postController.text, _images, selectedChip);
          ToastComponent().showMessage(Colors.green, 'Post successful');
          clearPost();
        } catch (e) {
          ToastComponent().showMessage(Colors.red, 'Failed to upload post: $e');
        } finally {
          pd.close();
        }
      }
    } else if (selectedChip == 'Missing Pets' || selectedChip == 'Found Pets') {
      // Implement functionality for Missing Pets or Found Pets
    } else if (selectedChip == 'Find a Home: Rescue & Shelter') {
      // Implement functionality for Find a Home: Rescue & Shelter
    } else if (selectedChip == 'Call for Aid') {
      // Implement functionality for Call for Aid
    } else if (selectedChip == 'Paw-some Experience') {
      // Implement functionality for Paw-some Experience
    } else if (selectedChip == 'Pet Adoption') {
      // Implement functionality for Pet Adoption
    } else if (selectedChip == 'Protect Our Pets: Report Abuse') {
      // Implement functionality for Protect Our Pets: Report Abuse
    } else if (selectedChip == 'Caring for Pets: Vet & Travel Insights') {
      // Implement functionality for Caring for Pets: Vet & Travel Insights
    } else if (selectedChip == 'Community Announcements') {
      // Implement functionality for Community Announcements
    } else {
      ToastComponent().showMessage(Colors.red, 'This feature is not yet available');
    }
  }

  // Set initial location
  Future<void> setInitialLocation() async {
    if (_locationInitialized) return; // Prevent multiple calls
    _locationInitialized = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    lat = position.latitude;
    long = position.longitude;
    notifyListeners();

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 15.0));
      addPin(LatLng(lat, long));
      notifyListeners();
    }
  }

  // Update location when map is clicked
  void updateLocation(LatLng newLocation) {
    if (selectedLocation == newLocation) return; // Avoid redundant updates
    selectedLocation = newLocation;
    addPin(newLocation);

    print('New location: $newLocation');
    notifyListeners();
  }

  // Add marker to map
  void addPin(LatLng position) {
    if (mapController != null) {
      mapController!.clearSymbols(); // Remove previous marker
      mapController!.addSymbol(SymbolOptions(
        geometry: position,
        iconImage: "custom_marker", // Default MapLibre marker
        iconSize: 2.0, // Adjust size if needed
      ));
      notifyListeners();
    }
  }

  // Load custom marker image
  Future<void> loadMarkerImage(MaplibreMapController controller) async {
    ByteData data = await rootBundle.load('assets/icon/location.png');
    Uint8List bytes = data.buffer.asUint8List();
    await controller.addImage("custom_marker", bytes);
    notifyListeners();
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

  void removePins() {
    if (mapController != null) {
      mapController!.clearSymbols();
      notifyListeners();
    }
  }

  // Method to fetch cat breeds
  Future<void> fetchCatBreeds() async {
    isLoading = true;
    notifyListeners();
    try {
      catBreeds = await PetAPI.fetchCatBreeds();
    } catch (e) {
      print('Failed to fetch cat breeds: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to fetch dog breeds
  Future<void> fetchDogBreeds() async {
    isLoading = true;
    notifyListeners();
    try {
      dogBreeds = await PetAPI.fetchDogBreeds();
    } catch (e) {
      print('Failed to fetch dog breeds: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRegions() async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/regions'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      regions = data.map((e) => RegionModel(region: e['name'], regionCode: e['code'])).toList();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProvinces(String regionCode) async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/provinces'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      provinces = data
          .where((e) => e['regionCode'].toString() == regionCode)
          .map((e) => ProvinceModel(provinceName: e['name'], provinceCode: e['code']))
          .toList();
    }
    selectedProvince = null; // Reset selected province
    selectedCity = null; // Reset selected city
    selectedBarangay = null; // Reset selected barangay
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCities(String provinceCode) async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/cities-municipalities'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      cities = data
          .where((e) => e['provinceCode'] == provinceCode)
          .map((e) => CityModel(cityName: e['name'], cityCode: e['code']))
          .toList();
    }
    selectedCity = null; // Reset selected city
    selectedBarangay = null; // Reset selected barangay
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBarangays(String municipalityCode) async {
    isLoading = true;
    notifyListeners();
    final response = await http.get(Uri.parse('https://psgc.gitlab.io/api/barangays'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      barangays = data
          .where((e) => e['municipalityCode'] == municipalityCode)
          .map((e) => BarangayModel(barangayName: e['name'], municipalityCode: e['code']))
          .toList();
    }
    selectedBarangay = null; // Reset selected barangay
    isLoading = false;
    notifyListeners();
  }

  void setSelectedRegion(RegionModel? region) {
    selectedRegion = region;
    selectedProvince = null;
    provinces = [];
    selectedCity = null;
    cities = [];
    selectedBarangay = null;
    barangays = [];
    if (region != null) {
      fetchProvinces(region.regionCode);
    }
    notifyListeners();
  }

  void setSelectedProvince(ProvinceModel? province) {
    selectedProvince = province;
    selectedCity = null;
    cities = [];
    selectedBarangay = null;
    barangays = [];
    if (province != null) {
      fetchCities(province.provinceCode);
    }
    notifyListeners();
  }


  void setSelectedCity(CityModel? city) {
    selectedCity = city;
    selectedBarangay = null;
    barangays = [];
    if (city != null) {
      fetchBarangays(city.cityCode);
    }
    notifyListeners();
  }

  void setSelectedBarangay(BarangayModel? barangay) {
    selectedBarangay = barangay;
    notifyListeners();
  }

  void selectedBreed(Breed? newValue) {
    if (selectedPetType == 'Cat') {
      selectPedBreed = newValue;
    } else {
      selectPedBreed = newValue;
    }
    notifyListeners();

  }

  void setPetType(String? newValue) {
    selectedPetType = newValue!;
    notifyListeners();
  }
}