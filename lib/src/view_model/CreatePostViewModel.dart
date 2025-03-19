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
import '../services/LocationService.dart';
import '../services/PetAPI.dart';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController petName = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController provinceCityMunicipalityBarangayController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final List<File> _images = [];
  var collarList = ['With Collar', 'Without Collar'];
  String selectedCollar = 'With Collar';
  // Add these fields to store the breeds
  List<String> petTypes = ['Cat', 'Dog', 'Others (for birds, reptiles, etc.)'];
  String selectedPetType = 'Cat';
  List<Breed> catBreeds = [];
  List<Breed> dogBreeds = [];
  List<String> petSize =['Tiny', 'Small', 'Medium', 'Large'];
  String selectedPetSize = 'Tiny';
  Breed? selectPedBreed;

  List <String> petGender = ['Male', 'Female', 'Can’t determine (for found pets)'];
  String selectedPetGender ='Male';

  var petAgeList = ['1 month', '2 months', '3 months', '4 months', '5 months', '6 months', '7 months', '8 months', '9 months', '10 months', '11 months', '1 year', '2 years', '3 years', '4 years', '5 years', '6 years', '7 years', '8 years', '9 years', '10 years', '11 years', '12 years', '13 years', '14 years', '15 years', '16 years', '17 years', '18 years', '19 years', '20 years', '21 years', '22 years', '23 years', '24 years', '25 years', '26 years', '27 years', '28 years', '29 years', '30 years', '31 years', '32 years', '33 years', '34 years', '35 years' ];
  var selectedPetAge = '1 month';

  List<String> colorpatter = [
    'Calico',
    'Tortoiseshell',
    'Tabby',
    'Short hair',
    'Fluffy/Long hair',
    'Tilapia/Tiger',
    'Cow',
    'Tuxedo',
    'Pointed',
    'Orange',
    'Smoke',
    'Cinnamon',
    'White/Cream',
    'Black/Black and Tan',
    'Brown',
    'Blue/Blue-gray',
    'Fawn',
    'Sable',
    'Merle/Dapple',
    'Brindle',
    'Bicolor',
    'Tricolor',
    'Spotted',
    'Piebald',
    'Ticked/Flecked',
    'Mask',
    'Others'
  ];

  String selectedColorPattern = 'Calico';

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

  // LocationService
  final LocationService locationService = LocationService();

  bool showDropdown = false;

  // Constructor
  CreatePostViewModel() {
    loadUserLocation();
    fetchRegions();

    searchController.addListener(() {
      showDropdown = searchController.text.isNotEmpty;
    });
  }

  // Load user location
  Future<void> loadUserLocation() async {
    await setInitialLocation();
    await fetchCatBreeds(); // Fetch cat breeds
    await fetchDogBreeds(); // Fetch dog breeds
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
    if(selectedChip =='Lost pets' || selectedChip == 'Found Pets'){
    postController.clear();
    _images.clear();
    selectedChip = 'Pet Appreciation';
    petName.clear();
    selectedColorPattern = 'Calico';
     selectedPetAge = '1 month';
    selectedPetType = 'Cat';
    selectPedBreed = null;
    selectedRegion = null;
    provinces = [];
    selectedProvince = null;
    cities = [];
    selectedCity = null;
    barangays = [];
    selectedBarangay = null;
    address.clear();
    searchController.clear();
    dateController.clear();
    selectedLocation = null;
    mapController!.clearSymbols();
    notifyListeners();
    }
    else{
    postController.clear();
    _images.clear();
    selectedChip = 'Pet Appreciation';
    notifyListeners();
    }
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
      if (postController.text.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
      } else if (_images.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'Please select an image');
      }
      else if (petName.text.isEmpty) {
        ToastComponent().showMessage(Colors.red , 'Please enter the name of the pet');
      }

      else if (selectedPetType == 'Cat' && selectPedBreed == null) {
        ToastComponent().showMessage(Colors.red, 'Please select the breed of the cat');
      }
      else if (selectedPetType == 'Dog' && selectPedBreed == null) {
        ToastComponent().showMessage(Colors.red, 'Please select the breed of the dog');
      }
      else if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
      } else if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
      } else if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
      } else if (selectedBarangay == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a barangay');
      } else {
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Posting...');
        try {
         var petData = {
           'post': postController.text,
            'pet_name': petName.text,
            'pet_type': selectedPetType..toString(),
            'pet_breed': selectPedBreed!.toString(),
            'pet_color': selectedColorPattern,
            'pet_age': selectedPetAge,
            'region': selectedRegion!.region,
            'province': selectedProvince!.provinceName,
            'city': selectedCity!.cityName,
           'gender': selectedPetGender,
            'size': selectedPetSize,
            'color': selectedColorPattern,
            'collar': selectedCollar,
            'barangay': selectedBarangay!.barangayName,
            'address': address.text,
            'lat': selectedLocation!.latitude,
            'long': selectedLocation!.longitude,
          };

          await postRepository.uploadPetData(_images, selectedChip, petData);
          ToastComponent().showMessage(Colors.green, '$selectedChip successful');
          clearPost();
        } catch (e) {
          ToastComponent().showMessage(Colors.red, 'Failed to upload post: $e');
        } finally {
          pd.close();
        }
      }
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

  // This is used for searched Locations
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

  // Remove the pins on the map
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
      catBreeds = PetAPI.getDefaultCatBreeds();
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
      dogBreeds = PetAPI.getDefaultDogBreeds();
    } catch (e) {
      print('Failed to fetch dog breeds: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Regions
  Future<void> fetchRegions() async {
    isLoading = true;
    notifyListeners();
    try {
      regions = await locationService.fetchRegions();
    } catch (e) {
      print('Failed to fetch regions: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Provinces
  Future<void> fetchProvinces(String regionCode) async {
    isLoading = true;
    notifyListeners();
    try {
      provinces = await locationService.fetchProvinces(regionCode);
    } catch (e) {
      print('Failed to fetch provinces: $e');
    } finally {
      selectedProvince = null;
      selectedCity = null;
      selectedBarangay = null;
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Cities
  Future<void> fetchCities(String provinceCode) async {
    isLoading = true;
    notifyListeners();
    try {
      cities = await locationService.fetchCities(provinceCode);
    } catch (e) {
      print('Failed to fetch cities: $e');
    } finally {
      selectedCity = null;
      selectedBarangay = null;
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Barrangay
  Future<void> fetchBarangays(String municipalityCode) async {
    isLoading = true;
    notifyListeners();
    try {
      barangays = await locationService.fetchBarangays(municipalityCode);
    } catch (e) {
      print('Failed to fetch barangays: $e');
    } finally {
      selectedBarangay = null;
      isLoading = false;
      notifyListeners();
    }
  }

  // This is for the region
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

  // This is for set city
  void setSelectedCity(CityModel? city) {
    selectedCity = city;
    selectedBarangay = null;
    barangays = [];
    if (city != null) {
      fetchBarangays(city.cityCode);
    }
    notifyListeners();
  }

  // This is for the barangay
  void setSelectedBarangay(BarangayModel? barangay) {
    selectedBarangay = barangay;
    notifyListeners();
  }

   // This is for the breed
  void selectedBreed(Breed? newValue) {
    selectPedBreed = newValue;
    notifyListeners();
  }

  // This is for the pet type
  void setPetType(String? newValue) {
    selectedPetType = newValue!;
    notifyListeners();
  }

  // This is for the color or pattern
  void setColor(String? newValue) {
    selectedColorPattern = newValue!;
    notifyListeners();
  }

  // This is for the color type
  void setCollarType(String? newValue) {
    selectedCollar = newValue!;
    notifyListeners();
  }

  // This is for the gender
  void setPetGender(String? newValue) {
    selectedPetGender = newValue!;
    notifyListeners();
  }

  // This is for the size
  void setPetSize(String? newValue) {
    selectedPetSize = newValue!;
    notifyListeners();
  }

  // This is for the age
  void setPetAge(String? newValue) {
    selectedPetAge = newValue!;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    showDropdown = false;
    notifyListeners();
  }
}