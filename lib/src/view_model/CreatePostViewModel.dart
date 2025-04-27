import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'package:pet_welfrare_ph/src/model/ImageModel.dart';
import 'package:pet_welfrare_ph/src/respository/LocationRespository.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:pet_welfrare_ph/src/services/OpenStreetMapService.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'dart:io';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:pet_welfrare_ph/src/model/RegionModel.dart';
import 'package:pet_welfrare_ph/src/model/ProvinceModel.dart';
import 'package:pet_welfrare_ph/src/model/CityModel.dart';
import 'package:pet_welfrare_ph/src/model/BarangayModel.dart';

import '../model/BreedModel.dart';
import '../model/TagModel.dart';
import '../services/LocationService.dart';
import '../services/PetAPI.dart';
import '../utils/NotificationUtils.dart';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController petName = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController provinceCityMunicipalityBarangayController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final List<File> _images = [];
  var collarList = ['With Collar', 'Without Collar'];
  String selectedCollar = 'With Collar';

  // Add these fields to store the breeds
  List<String> petTypes = ['Cat', 'Dog', 'Others (for birds, reptiles, etc.)'];
  String selectedPetType = 'Dog';
  List<Breed> catBreeds = [];
  List<Breed> dogBreeds = [];
  List<String> petSize =['Tiny', 'Small', 'Medium', 'Large'];
  String selectedPetSize = 'Tiny';
  Breed? selectedCatBreed;
  Breed? selectedDogBreed;

  List <String> petGender = ['Male', 'Female', 'Can’t determine (for found pets)'];
  String selectedPetGender ='Male';

  var petAgeList = ['1 month', '2 months', '3 months', '4 months', '5 months', '6 months', '7 months', '8 months', '9 months', '10 months', '11 months', '1 year', '2 years', '3 years', '4 years', '5 years', '6 years', '7 years', '8 years', '9 years', '10 years', '11 years', '12 years', '13 years', '14 years', '15 years', '16 years', '17 years', '18 years', '19 years', '20 years', '21 years', '22 years', '23 years', '24 years', '25 years', '26 years', '27 years', '28 years', '29 years', '30 years', '31 years', '32 years', '33 years', '34 years', '35 years' ];
  var selectedPetAge = '1 month';

  bool isDone = false;


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

  List<String> chipLabels1 = [];

   PostRepository postRepository = PostRepositoryImpl();

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

  // Load the establisment that user created
  List<EstablishmentModel> establishments = [];

  Locationrespository locationrespository = LocationrespositoryImpl();

  Stream<List<EstablishmentModel>> get establishmentStream => locationrespository.getData1();
  EstablishmentModel? selectedEstablisment;

  // OpenStreetMapService
  final OpenStreetMapService _openStreetMapService = OpenStreetMapService();

  // LocationService
  final LocationService locationService = LocationService();

  SessionManager sessionManager = SessionManager();

  bool showDropdown = false;

  List<String> bankType = ['Gcash', 'Paymaya', 'Coins.ph', 'BDO', 'BPI', 'Metrobank', 'Unionbank', 'Security Bank', 'Landbank', 'RCBC', 'PNB', 'China Bank', 'Eastwest Bank', 'PSBank', 'DBP', 'Maybank', 'CIMB', 'ING', 'Others'];
  String? selectedBankType = 'Gcash';

  List<String> donationType =['Pet Foods or treats', 'Pet supplies', 'Vitamins and/or medicines', 'Vet bills', 'Cleaning supplies', 'Litter sands' , 'Others'];
  String? selectedDonationType = 'Pet Foods or treats';

  List<String> typeOfDonation = ['Cash', 'Non-cash/In-kind'];
  String? selectedTypeOfDonation = 'Cash';

  List<String> tags = [];

  String role = '';

  // This is for the edit post variables
  List<ImageModel> imagesList = [];
  List<TagModel> tagsList = [];
  String? selectedTag;

  String postID = '';
  Stream<List<ImageModel>> get imageStream => postRepository.loadImage(postID);
  Stream<List<TagModel>> get tagStream => postRepository.getTagData(postID);


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
  Future.wait([
  loadList(),
   setInitialLocation(),
   fetchCatBreeds(),
   fetchDogBreeds(),
   loadEstablishment(selectedEstablisment!),
  ]);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (_images.length < 5) {
        _images.add(File(image.path));
        notifyListeners();
      } else {
        ToastComponent().showMessage(Colors.red, 'You can only upload up to 5 images');
      }
    }
  }

  Future<void> loadList() async {
    var userdata = await sessionManager.getUserInfo();
    role = userdata!['role'];

    if (role == 'Admin' || role == 'Sub-admin') {
      chipLabels1 = [
        'Community Announcements'
      ];
      selectedChip = 'Community Announcements';
    } else if (role == 'Pet Rescuer' || role.toLowerCase() == 'pet shelter') {
      chipLabels1 = [
        'Pet Appreciation',
        'Missing Pets',
        'Found Pets',
        'Pets For Rescue',
        'Call for Aid',
        'Paw-some Experience',
        'Pet Adoption',
        'Protect Our Pets: Report Abuse',
        'Pet Care Insights',
      ];
    } else {
      chipLabels1 = [
        'Pet Appreciation',
        'Missing Pets',
        'Found Pets',
        'Pets For Rescue',
        'Paw-some Experience',
        'Pet Adoption',
        'Protect Our Pets: Report Abuse',
        'Pet Care Insights',
      ];
    }

    notifyListeners();
  }

  void setSelectRole(String selectedValue) {
    selectedChip = selectedValue;
    notifyListeners();
  }

  // This is for clear post
  Future <void> clearPost() async {
    postController.clear();
    _images.clear();
    selectedChip = role == 'Admin' || role == 'Sub-admin' ? 'Community Announcements' : 'Pet Appreciation';
    petName.clear();
    selectedColorPattern = 'Calico';
     selectedPetAge = '1 month';
    selectedPetType = 'Cat';
    selectedDogBreed = null;
    selectedCatBreed = null;
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
    selectedDonationType = 'Pet Foods or treats';
    selectedTypeOfDonation = 'Cash';
    selectedBankType = 'Gcash';
    amountController.clear();
    bankNameController.clear();
    accountNameController.clear();
    tagController.clear();
    tags.clear();
    clinicNameController.clear();
    notifyListeners();
  }

  Future<void> postNow(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Posting...');
    try {
      if (selectedChip == "Pet Appreciation") {
        if (tags.isEmpty) {
          ToastComponent().showMessage(
              Colors.red, 'Please add at least one tag');
        }
        if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        } else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        } else {
          try {

            Future.wait([
              postRepository.uploadPost(
                  postController.text, _images, selectedChip, tags),
              clearPost()
            ]);
            ToastComponent().showMessage(Colors.green, 'Post successful');
            isDone = true;
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      }
      else if(selectedChip =='Paw-some Experience'){
        if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        } else if (tags.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please add at least one tag');
        } else {
          try {

            Future.wait([
              postRepository.uploadPost(
                postController.text, _images, selectedChip, tags),
              clearPost()
            ]);
            ToastComponent().showMessage(Colors.green, 'Post successful');
            isDone = true;
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      }
      else if (selectedChip == 'Missing Pets' || selectedChip == 'Found Pets') {
        // Implement functionality for Missing Pets or Found Pets
        if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        }
        else if (address.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Address cannot be empty');
        } else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        } else if (petName.text.isEmpty) {
          ToastComponent().showMessage(
              Colors.red, 'Please enter the name of the pet');
        } else if (selectedPetType == 'Cat' && selectedCatBreed == null ||
            selectedPetType == 'Dog' && selectedDogBreed == null) {
          ToastComponent().showMessage(Colors.red, selectedPetType == 'Cat'
              ? 'Please select the breed of the cat'
              : 'Please select the breed of the dog');
        } else if (selectedRegion == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a region');
        } else if (selectedProvince == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a province');
        } else if (selectedCity == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a city');
        } else if (selectedBarangay == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a barangay');
        } else {
          try {
            var petData = {
              'post': postController.text,
              'pet_name': petName.text,
              'pet_type': selectedPetType.toString(),
              'pet_breed': selectedPetType == 'Cat'
                  ? selectedCatBreed!.name
                  : selectedDogBreed!.name,
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
              'date': dateController.text,
              'lat': selectedLocation!.latitude,
              'long': selectedLocation!.longitude,
            };


            Future.wait([postRepository.uploadPetData(
            _images, selectedChip, petData, tags),
              clearPost()
            ]);
            ToastComponent().showMessage(
                Colors.green, '$selectedChip successful');
            isDone = true;
            notifyListeners();
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      } else if (selectedChip == 'Find a Home: Rescue & Shelter') {
        // Implement functionality for Find a Home: Rescue & Shelter
      } else if (selectedChip == 'Call for Aid') {
        // Implement functionality for Call for Aid
        if (accountNameController.text.isEmpty) {
          ToastComponent().showMessage(
              Colors.red, 'Account name cannot be empty');
        } else if (address.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Address cannot be empty');
        } else if (amountController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Amount cannot be empty');
        } else if (bankNameController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Bank name cannot be empty');
        } else if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        } else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        } else {
          try {
            var petData = {
              'post': postController.text,
              'amount': amountController.text,
              'account_name': bankNameController.text,
              'account_number': accountNameController.text,
              'bank_type': selectedBankType,
              'purpose_of_donation': selectedDonationType,
              'donation_type': selectedTypeOfDonation,
            };

            Future.wait([postRepository.uploadDonation(
            _images, selectedChip, petData, tags),
              clearPost()
            ]);
            isDone = true;
            notifyListeners();
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      } else if (selectedChip == 'Pet Adoption') {
        // Implement functionality for Pet Adoption
        if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        } else if (address.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Address cannot be empty');
        } else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        } else if (petName.text.isEmpty) {
          ToastComponent().showMessage(
              Colors.red, 'Please enter the name of the pet');
        } else if (selectedPetType == 'Cat' && selectedCatBreed == null) {
          ToastComponent().showMessage(
              Colors.red, 'Please select the breed of the cat');
        } else if (selectedPetType == 'Dog' && selectedDogBreed == null) {
          ToastComponent().showMessage(
              Colors.red, 'Please select the breed of the dog');
        } else if (selectedRegion == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a region');
        } else if (selectedProvince == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a province');
        } else if (selectedCity == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a city');
        } else if (selectedBarangay == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a barangay');
        } else {
          var petData = {
            'post': postController.text,
            'pet_name': petName.text,
            'pet_type': selectedPetType.toString(),
            'pet_breed': selectedPetType == 'Cat'
                ? selectedCatBreed!.name
                : selectedDogBreed!.name,
            'pet_color': selectedColorPattern,
            'pet_age': selectedPetAge,
            'region': selectedRegion!.region,
            'province': selectedProvince!.provinceName,
            'city': selectedCity!.cityName,
            'gender': selectedPetGender,
            'size': selectedPetSize,
            'color': selectedColorPattern,
            'barangay': selectedBarangay!.barangayName,
            'address': address.text,
            'date': dateController.text,
          };

          try {

            Future.wait([
              postRepository.uploadAdoption(
            _images, selectedChip, petData, tags),
              clearPost()
            ]);
            ToastComponent().showMessage(
                Colors.green, '$selectedChip successful');
            isDone = true;
            notifyListeners();
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      } else if (selectedChip == 'Protect Our Pets: Report Abuse') {
        // Implement functionality for Protect Our Pets: Report Abuse
        if(postController.text.isEmpty){
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        }
        if(tags.isEmpty){
          ToastComponent().showMessage(Colors.red, 'Please add at least one tag');
        }
        else{
          try {
            var petData = {
              'post': postController.text,
            };
            Future.wait([
            postRepository.uploadReportAbuse(
            _images, selectedChip, petData, tags),
              clearPost()
            ]);
            isDone = true;
            notifyListeners();
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      } else if (selectedChip == 'Pet Care Insights') {
        if (clinicNameController.text.isEmpty) {
          ToastComponent().showMessage(
              Colors.red, 'Clinic name cannot be empty');
        }
        else if (address.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Address cannot be empty');
        }
        else if (selectedRegion == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a region');
        }
        else if (selectedProvince == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a province');
        }

        else if (selectedCity == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a city');
        }
        else if (selectedBarangay == null) {
          ToastComponent().showMessage(Colors.red, 'Please select a barangay');
        }
        else if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        }
        else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        } else {
          try {
            var petData = {
              'post': postController.text,
              'clinic_name': clinicNameController.text,
              'region': selectedRegion!.region,
              'province': selectedProvince!.provinceName,
              'city': selectedCity!.cityName,
              'barangay': selectedBarangay!.barangayName,
              'address': address.text,
            };
            Future.wait([
            postRepository.uploadVetTravel(
            _images, selectedChip, petData, tags),
            clearPost()
            ]);
            isDone = true;

            notifyListeners();
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      }
      else if (selectedChip == 'Pets For Rescue') {
        if (address.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Address cannot be empty');
        }
        else if (postController.text.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        }
        else if (_images.isEmpty) {
          ToastComponent().showMessage(Colors.red, 'Please select an image');
        }
        else if (selectedPetType == 'Cat' && selectedCatBreed == null ||
            selectedPetType == 'Dog' && selectedDogBreed == null) {
          ToastComponent().showMessage(Colors.red, selectedPetType == 'Cat'
              ? 'Please select the breed of the cat'
              : 'Please select the breed of the dog');
        }
         else{
            var petRescueData = {
              'post': postController.text,
              'pet_type': selectedPetType.toString(),
              'pet_breed': selectedPetType == 'Cat'
                  ? selectedCatBreed!.name
                  : selectedDogBreed!.name,
              'pet_color': selectedColorPattern,
              'pet_gender': selectedPetGender,
              'pet_size': selectedPetSize,
              'address': address.text,
            };

            try {
              await postRepository.uploadPetRescue(
                  _images, selectedChip, petRescueData, tags);
              ToastComponent().showMessage(
                  Colors.green, '$selectedChip successful');
              clearPost();
              isDone = true;

              notifyListeners();
            } catch (e) {
              print('Failed to post: $e');
            }
        }
      }

      else if (selectedChip =="Community Announcements"){
        if(postController.text.isEmpty ){
          ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
        }
        else if(tags.isEmpty){
          ToastComponent().showMessage(Colors.red, 'Please add at least one tag');
        }
        else{
          try {
            await postRepository.uploadPost(
                postController.text, _images, selectedChip, tags);
            ToastComponent().showMessage(Colors.green, 'Post successful');
            clearPost();
            isDone = true;
          } catch (e) {
            print('Failed to post: $e');
          }
        }
      }
      else {
        ToastComponent().showMessage(Colors.red, 'Please select a post type');
      }
    } catch (e) {
      print('Failed to post: $e');
    } finally {
      pd.close();
      if (isDone) {
        if (context.mounted) {
          debugPrint('Context is mounted, closing the dialog.');
          ToastComponent().showMessage(Colors.green, 'Post successful');
          Navigator.pop(context);
          isDone = false;
        } else {
          debugPrint('Context is not mounted, cannot close the dialog.');
          isDone = false;
        }
      }
    }

    notifyListeners();
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
  Future <void> addPin(LatLng position) async {
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
  Future <void> setSelectedRegion(RegionModel? region)  async {
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

  Future <void> setSelectedProvince(ProvinceModel? province) async {
    selectedProvince = province;
    selectedCity = null;
    cities = [];
    selectedBarangay = null;
    barangays = [];
    if (province != null) {
      await fetchCities(province.provinceCode);
    }
    notifyListeners();
  }

  // This is for set city
  Future <void> setSelectedCity(CityModel? city) async {
    selectedCity = city;
    selectedBarangay = null;
    barangays = [];
    if (city != null) {
      await fetchBarangays(city.cityCode);
    }
    notifyListeners();
  }

  // This is for the barangay
  Future <void> setSelectedBarangay(BarangayModel? barangay) async{
    selectedBarangay = barangay;
    notifyListeners();
  }

   // This is for the cat breed
  Future <void> selectedCatBreed1(Breed? newValue) async {
    selectedCatBreed = newValue;
    notifyListeners();
  }

  // This is for the dog breed
  Future <void> selectedDogBreed2(Breed? newValue) async{
    selectedDogBreed = newValue;
    notifyListeners();
  }

  // This is for the pet type
  Future <void> setPetType(String? newValue) async {
    selectedPetType = newValue!;
    notifyListeners();
  }

  // This is for the color or pattern
  Future <void> setColor(String? newValue) async {
    selectedColorPattern = newValue!;
    notifyListeners();
  }

  // This is for the color type
  Future <void> setCollarType(String? newValue) async {
    selectedCollar = newValue!;
    notifyListeners();
  }

  // This is for the gender
  Future <void> setPetGender(String? newValue) async{
    selectedPetGender = newValue!;
    notifyListeners();
  }

  // This is for the size
  Future <void> setPetSize(String? newValue) async {
    selectedPetSize = newValue!;
    notifyListeners();
  }

  // This is for the age
  Future <void> setPetAge(String? newValue) async {
    selectedPetAge = newValue!;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    showDropdown = false;
    notifyListeners();
  }

  Future <void> loadEstablishment(EstablishmentModel establishment) async {
    selectedEstablisment = establishment;
    notifyListeners();
  }

  Future <void> setSelectedEstablishment(EstablishmentModel? establishment) async {
    selectedEstablisment = establishment;
    notifyListeners();
  }

  void notifyNotice(BuildContext context) async {
    String filename;

    if(selectedChip == 'Pet Appreciation'){
      filename = 'assets/word/petappreciation_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );



    }
    if(selectedChip == 'Missing Pets' || selectedChip == 'Found Pets'){

      filename = 'assets/word/missingAndFoundPet_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    if(selectedChip == 'Find a Home: Rescue & Shelter'){
      filename = 'assets/word/petappreciation_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    if(selectedChip == 'Call for Aid'){
      filename = 'assets/word/callforAid_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

    }

    if(selectedChip == 'Paw-some Experience'){
      filename = 'assets/word/petexperience_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    if(selectedChip == 'Pet Adoption'){

      filename = 'assets/word/petAdoption_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    if(selectedChip == 'Protect Our Pets: Report Abuse'){
      filename = 'assets/word/reportAbuse_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

    }

    if(selectedChip == 'Pet Care Insights'){
      filename = 'assets/word/petexperience_notice.txt';
      String data = await loadNotify(filename);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("NOTICE BEFORE POSTING"),
            content: SingleChildScrollView(
              child: Text(data, textAlign: TextAlign.justify),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );

    }

    if(selectedChip == 'Community Announcements'){

    }
    notifyListeners();
  }

  Future<String> loadNotify(String filename) async {
    // Load text from the text file
    String text = await rootBundle.loadString(filename);
    return text;
  }

  // This is for the donation type set the bank
  Future <void> setSelectedBank(String? newValue) async {
    selectedBankType = newValue!;
    notifyListeners();
  }

  // This is for te set donation type
  Future <void> setSelectDonation(String? newValue) async {
    selectedDonationType = newValue!;
    notifyListeners();
  }

  Future <void> setselectedDonation(String? newValue)  async {
    selectedTypeOfDonation = newValue!;
    notifyListeners();
  }

  // Add the tag to the database
 Future <void> addTag(String tag) async{
    if (tag.isNotEmpty && !tags.contains(tag)) {
       try{
         await postRepository.addTag(tag, postID);

         await for (var tags in tagStream) {
           tagsList.clear();
           tagsList.addAll(tags);
           notifyListeners();
         }
       }
        catch (e) {
          print('Failed to add tag: $e');
          ToastComponent().showMessage(Colors.red, 'Failed to add tag: $e');
        }
      notifyListeners();
    }
  }

  void setSelectedTag(String tag) {
    selectedTag = tag;
    notifyListeners();
  }

  Future <void> removeTag(String tagname) async {
    try {

      // Update the local list
      tagsList.removeWhere((tag) => tag.name == tagname);
      // Remove the tag from the backend
      await postRepository.removeTag(tagname, postID);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Failed to remove tag: $e');
    }
  }

  // This is for  the update section here do not touch
  Future <void> setSelectedLocation(LatLng location)  async {
    selectedLocation = location;
    notifyListeners();
  }


  Future <void> LoadEditDetails(String postId, String category) async {
    postID = postId;
    try {
      // Fetch post details
      Map<String, dynamic> postDetails = await postRepository.getPostDetails(postId, category);

      if (postDetails.isNotEmpty) {
        // Populate post-related fields
        postController.text = postDetails['PostDescription'] ?? '';
        selectedChip = category;

        // Listen to image stream and update imagesList
        await for (var images in imageStream) {
          imagesList.clear();
          imagesList.addAll(images);
          notifyListeners();
          break; // Stop after the first update
        }

        // Listen to tag stream and update tagsList
        await for (var tagdata in tagStream) {
          tagsList.clear();
          tagsList.addAll(tagdata);
          notifyListeners();
          break; // Stop after the first update
        }

        // Populate pet-related fields if applicable
        if (category == 'Missing Pets' || category == 'Found Pets') {
          petName.text = postDetails['PetName'] ?? '';
          selectedPetType = postDetails['PetType'] ?? 'Cat';
          selectedColorPattern = postDetails['PetColor'] ?? 'Unknown';
          selectedPetAge = postDetails['PetAge'] ?? 'Unknown';
          selectedPetGender = postDetails['PetGender'] ?? 'Male';
          selectedPetSize = postDetails['PetSize'] ?? 'Tiny';
          selectedCollar = postDetails['PetCollar'] ?? 'None';
          address.text = postDetails['Address'] ?? '';

          // Match the region and fetch provinces
          await fetchRegions();
          selectedRegion = postDetails['Region'] != null
              ? regions.firstWhere(
                (region) => region.region.trim().toLowerCase() == postDetails['Region'].trim().toLowerCase(),
            orElse: () => RegionModel(region: "Unknown", regionCode: ""),
          )
              : null;

          if (selectedRegion != null) {

          }

          await fetchProvinces(selectedRegion!.regionCode);
          // Match the province and fetch cities
          selectedProvince = postDetails['Province'] != null
              ? provinces.firstWhere(
                (province) => province.provinceName.trim().toLowerCase() == postDetails['Province'].trim().toLowerCase(),
            orElse: () => ProvinceModel(provinceName: "Unknown", provinceCode: ""),
          )
              : null;

          // Fetch cities and ensure the list is populated
          await fetchCities(selectedProvince!.provinceCode);

        // Match the city and assign directly from the cities list
          selectedCity = postDetails['City'] != null
              ? cities.firstWhere(
                (city) => city.cityName.trim().toLowerCase() == postDetails['City']!.trim().toLowerCase(),
            orElse: () => CityModel(cityName: "Unknown", cityCode: ""),
          )
              : null;

        // Ensure the selectedCity is part of the cities list
          if (selectedCity != null && !cities.contains(selectedCity)) {
            selectedCity = null; // Reset if not found in the list
          }


          // Match the barangay
          await fetchBarangays(selectedCity!.cityCode);
          selectedBarangay = postDetails['Barangay'] != null
              ? barangays.firstWhere(
                (barangay) => barangay.barangayName.trim().toLowerCase() == postDetails['Barangay'].trim().toLowerCase(),
            orElse: () => BarangayModel(municipalityCode: "", barangayName: "Unknown"),
          )
              : null;



           if (selectedPetType == 'Dog') {
             fetchDogBreeds();
             selectedDogBreed = postDetails['PetBreed'] != null
                 ? dogBreeds.firstWhere(
                   (breed) => breed.name == postDetails['PetBreed'],
               orElse: () =>
                   Breed(
                       id: "", name: "Unknown", temperament: "", imageUrl: ""),
             )
                 : null;
           }


          if (selectedPetType == 'Cat') {
            fetchCatBreeds();
            selectedCatBreed = postDetails['PetBreed'] != null
                ? catBreeds.firstWhere(
                  (breed) => breed.name == postDetails['PetBreed'],
              orElse: () =>
                  Breed(
                      id: "", name: "Unknown", temperament: "", imageUrl: ""),
            )
                : null;
          }


          dateController.text = postDetails['Date'] ?? '';

          double lat = (postDetails['Latitude'] != null && postDetails['Latitude'].toString().isNotEmpty)
              ? double.tryParse(postDetails['Latitude'].toString()) ?? 0
              : 0;
          double long = (postDetails['Longitude'] != null && postDetails['Longitude'].toString().isNotEmpty)
              ? double.tryParse(postDetails['Longitude'].toString()) ?? 0
              : 0;
          selectedLocation = LatLng(lat,long);

          ToastComponent().showMessage(Colors.green, 'Location loaded successfully $selectedLocation');

          await addPin(selectedLocation!);


        }

        // for pet  for rescue
        if(category =='Pets For Rescue'){
          address.text = postDetails['Address'] ?? '';
          selectedPetType = postDetails['PetType'] ?? 'Unknown';
          selectedPetSize = postDetails['PetSize'] ?? 'Tiny';
          selectedPetGender  = postDetails['PetGender'] ??'';
          selectedColorPattern = postDetails['PetColor'] ?? 'Unknown';


          if (selectedPetType == 'Dog') {
            fetchDogBreeds();
            selectedDogBreed = postDetails['PetBreed'] != null
                ? dogBreeds.firstWhere(
                  (breed) => breed.name == postDetails['PetBreed'],
              orElse: () =>
                  Breed(
                      id: "", name: "Unknown", temperament: "", imageUrl: ""),
            )
                : null;
          }


          if (selectedPetType == 'Cat') {
            fetchCatBreeds();
            selectedCatBreed = postDetails['PetBreed'] != null
                ? catBreeds.firstWhere(
                  (breed) => breed.name == postDetails['PetBreed'],
              orElse: () =>
                  Breed(
                      id: "", name: "Unknown", temperament: "", imageUrl: ""),
            )
                : null;
          }

        }

        // for pet adoption
        if(category=='Pet Adoption'){
          address.text = postDetails['Address'] ?? '';
          petName.text = postDetails['PetName'] ?? '';
          selectedPetType = postDetails['PetType'] ?? 'Cat';
          selectedColorPattern = postDetails['PetColor'] ?? 'Unknown';
          selectedPetAge = postDetails['PetAge'] ?? 'Unknown';
          selectedPetGender = postDetails['PetGender'] ?? 'Male';
          selectedPetSize = postDetails['PetSize'] ?? 'Tiny';
          address.text = postDetails['Address'] ?? '';

          // Match the region and fetch provinces
          await fetchRegions();
          selectedRegion = postDetails['Region'] != null
              ? regions.firstWhere(
                (region) => region.region.trim().toLowerCase() == postDetails['Region'].trim().toLowerCase(),
            orElse: () => RegionModel(region: "Unknown", regionCode: ""),
          )
              : null;

          if (selectedRegion != null) {

          }

          await fetchProvinces(selectedRegion!.regionCode);
          // Match the province and fetch cities
          selectedProvince = postDetails['Province'] != null
              ? provinces.firstWhere(
                (province) => province.provinceName.trim().toLowerCase() == postDetails['Province'].trim().toLowerCase(),
            orElse: () => ProvinceModel(provinceName: "Unknown", provinceCode: ""),
          )
              : null;

          // Fetch cities and ensure the list is populated
          await fetchCities(selectedProvince!.provinceCode);

          // Match the city and assign directly from the cities list
          selectedCity = postDetails['City'] != null
              ? cities.firstWhere(
                (city) => city.cityName.trim().toLowerCase() == postDetails['City']!.trim().toLowerCase(),
            orElse: () => CityModel(cityName: "Unknown", cityCode: ""),
          )
              : null;

          // Ensure the selectedCity is part of the cities list
          if (selectedCity != null && !cities.contains(selectedCity)) {
            selectedCity = null; // Reset if not found in the list
          }


          // Match the barangay
          await fetchBarangays(selectedCity!.cityCode);
          selectedBarangay = postDetails['Barangay'] != null
              ? barangays.firstWhere(
                (barangay) => barangay.barangayName.trim().toLowerCase() == postDetails['Barangay'].trim().toLowerCase(),
            orElse: () => BarangayModel(municipalityCode: "", barangayName: "Unknown"),
          )
              : null;



          if (selectedPetType == 'Dog') {
            fetchDogBreeds();
            selectedDogBreed = postDetails['PetBreed'] != null
                ? dogBreeds.firstWhere(
                  (breed) => breed.name == postDetails['PetBreed'],
              orElse: () =>
                  Breed(
                      id: "", name: "Unknown", temperament: "", imageUrl: ""),
            )
                : null;
          }


          if (selectedPetType == 'Cat') {
            fetchCatBreeds();
            selectedCatBreed = postDetails['PetBreed'] != null
                ? catBreeds.firstWhere(
                  (breed) => breed.name == postDetails['PetBreed'],
              orElse: () =>
                  Breed(
                      id: "", name: "Unknown", temperament: "", imageUrl: ""),
            )
                : null;
          }
        }

        if(category =='Pet Care Insights'){
          address.text = postDetails['Address'] ?? '';
          clinicNameController.text = postDetails['ClinicName'] ?? '';
          // Match the region and fetch provinces
          await fetchRegions();
          selectedRegion = postDetails['Region'] != null
              ? regions.firstWhere(
                (region) => region.region.trim().toLowerCase() == postDetails['Region'].trim().toLowerCase(),
            orElse: () => RegionModel(region: "Unknown", regionCode: ""),
          )
              : null;

          if (selectedRegion != null) {

          }

          await fetchProvinces(selectedRegion!.regionCode);
          // Match the province and fetch cities
          selectedProvince = postDetails['Province'] != null
              ? provinces.firstWhere(
                (province) => province.provinceName.trim().toLowerCase() == postDetails['Province'].trim().toLowerCase(),
            orElse: () => ProvinceModel(provinceName: "Unknown", provinceCode: ""),
          )
              : null;

          // Fetch cities and ensure the list is populated
          await fetchCities(selectedProvince!.provinceCode);

          // Match the city and assign directly from the cities list
          selectedCity = postDetails['City'] != null
              ? cities.firstWhere(
                (city) => city.cityName.trim().toLowerCase() == postDetails['City']!.trim().toLowerCase(),
            orElse: () => CityModel(cityName: "Unknown", cityCode: ""),
          )
              : null;

          // Ensure the selectedCity is part of the cities list
          if (selectedCity != null && !cities.contains(selectedCity)) {
            selectedCity = null; // Reset if not found in the list
          }


          // Match the barangay
          await fetchBarangays(selectedCity!.cityCode);
          selectedBarangay = postDetails['Barangay'] != null
              ? barangays.firstWhere(
                (barangay) => barangay.barangayName.trim().toLowerCase() == postDetails['Barangay'].trim().toLowerCase(),
            orElse: () => BarangayModel(municipalityCode: "", barangayName: "Unknown"),
          )
              : null;

        }

      }
    } catch (e) {
      ToastComponent().showMessage(Colors.red, 'Failed to load details: $e');
    }
    notifyListeners();
  }

  Future <void> insertSelectedImage(String id) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (imagesList.length < 5) {
        try {
          // Convert image.path to a File object
          File imageFile = File(image.path);
          await postRepository.addImage(id, imageFile);

          // Fetch updated images from the stream
          await for (var images in imageStream) {
            imagesList.clear();
            imagesList.addAll(images);
            notifyListeners(); // Notify listeners after updating the list
            break; // Stop after the first update
          }
        } catch (e) {
          ToastComponent().showMessage(Colors.red, 'Failed to upload image: $e');
        }
      } else {
        ToastComponent().showMessage(Colors.red, 'You can only upload up to 5 images');
      }
    }
    notifyListeners();
  }

  void removeImageData(String imageId, String url, String postId) async {
    _images.removeWhere((image) => image.path == imageId);
    await postRepository.deleteImage(imageId, url, postId);
    notifyListeners();

  }

  Future  <void> removeImage(File p1) async  {
    _images.removeWhere((image) => image.path == p1.path);
    notifyListeners();
  }

  Future <void> editNow(BuildContext context, String category)  async {
    var data = {
      'post': postController.text,
       'pet_name': petName.text,
      'pet_type': selectedPetType.toString(),
      'pet_breed': selectedPetType == 'Cat'
          ? selectedCatBreed!.name
          : selectedDogBreed!.name,
      'pet_color': selectedColorPattern,
      'pet_age': selectedPetAge,
      'date': dateController.text,
      'lat': selectedLocation!.latitude,
      'long' :selectedLocation!.longitude,
      'pet_size': selectedPetSize,
       'pet_gender' :selectedPetGender,
      'region': selectedRegion!.region,
      'province': selectedProvince!.provinceName,
       'city': selectedCity!.cityName,
        'barangay' : selectedBarangay!.barangayName,
      'address': address.text,

    };
    await postRepository.editDetails(category, data, postID);
    notifyListeners();
  }

  void clearAllEdits(){
    postController.clear();

    petName.clear();
    dateController.clear();
    selectedProvince = null;
    selectedCity = null;
    selectedBarangay = null;
    selectedRegion = null;
    selectedLocation = null;

    regions = [];
    provinces = [];
    cities = [];
    barangays = [];

    selectedCatBreed = null;
    selectedDogBreed = null;

    tagsList = [];

    imagesList = [];
 notifyListeners();
  }
}