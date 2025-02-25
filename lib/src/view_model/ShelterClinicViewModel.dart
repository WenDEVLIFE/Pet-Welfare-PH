import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'package:pet_welfrare_ph/src/respository/LocationRespository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

class ShelterClinicViewModel extends ChangeNotifier {
  final TextEditingController shelterNameController = TextEditingController();
  final TextEditingController shelterDescriptionController = TextEditingController();
  final TextEditingController shelterAddressController = TextEditingController();
  final TextEditingController shelterPhoneNumber = TextEditingController();
  final TextEditingController shelterEmailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  final Locationrespository _addLocationRespository = LocationrespositoryImpl();
  String shelterImage = '';
  String selectedImage = '';
  bool isNetworkImage = false;
  LatLng? selectedLocation;
  bool _locationInitialized = false;
  double lat = 0.0;
  double long = 0.0;
  double newlat = 0.0;
  double newlong = 0.0;
  MaplibreMapController? mapController;
  var establishmentType = ['Shelter', 'Clinic'];
  var selectEstablishment = 'Shelter';
  List<EstablishmentModel> establismentList = [];
  List<EstablishmentModel> filteredEstablisment = [];

  List<EstablishmentModel> get establismentListdata => filteredEstablisment;

  Stream<List<EstablishmentModel>> get establishmentStream => _addLocationRespository.getData();

  String get selectEstablishment1 => selectEstablishment;



  void setImageUrl(String url) {
    shelterImage = url;
    isNetworkImage = true;
    notifyListeners();
  }


  // Pick image for profile
  Future<void> pickImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      shelterImage = pickedFile.path;
      isNetworkImage = false;
      notifyListeners();
    }
  }

  Future<void> pickImageCamera() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = pickedFile.path;
      notifyListeners();
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

  // Update establishment type
  void updateEstablishmentType(String newType) {
    selectEstablishment = newType;
    notifyListeners();
  }

  Future<void> insertActionEvent(BuildContext context) async {
    bool isShelterName = await _addLocationRespository.checkIfNameExists(shelterNameController.text);

    if (shelterNameController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the name of the shelter');
    } else if (shelterDescriptionController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the description of the shelter');
    } else if (shelterAddressController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the address of the shelter');
    } else if (shelterPhoneNumber.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the phone number of the shelter');
    } else if (shelterEmailController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the email of the shelter');
    } else if (shelterImage.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please select an image for the shelter');
    } else if (selectedLocation == null) {
      ToastComponent().showMessage(Colors.red, 'Please select the location of the shelter');
    } else if (isShelterName) {
      ToastComponent().showMessage(Colors.red, 'Shelter name already exists');
    } else {
      // Map for locations
      var locationData = {
        'EstablishmentName': shelterNameController.text,
        'EstablishmentDescription': shelterDescriptionController.text,
        'EstablishmentAddress': shelterAddressController.text,
        'EstablishmentPhoneNumber': shelterPhoneNumber.text,
        'EstablishmentEmail': shelterEmailController.text,
        'EstablishmentType': selectEstablishment,
        'Latitude': selectedLocation!.latitude,
        'Longitude': selectedLocation!.longitude,
        'Image': shelterImage,
        'EstablishmentOwnerID': FirebaseAuth.instance.currentUser!.uid,
        'EstablishmentStatus': 'Pending',
        'ClearFields': clearTextFields
      };

      // add the establishment to the database
      _addLocationRespository.addLocation(locationData, context);
    }
  }

  void clearTextFields() {
    shelterNameController.clear();
    shelterDescriptionController.clear();
    shelterAddressController.clear();
    shelterPhoneNumber.clear();
    shelterEmailController.clear();
    selectEstablishment = 'Shelter';
    selectedLocation = null;
    notifyListeners();
  }

  void setEstablishment(List<EstablishmentModel> establishment) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      establismentList = establishment;
      filteredEstablisment = establishment;
      notifyListeners();
    });
  }

  void filterSubscriptions(String query) {
    if (query.isEmpty) {
      filteredEstablisment = establismentList;
    } else {
      filteredEstablisment = establismentList.where((establishment) {
        return establishment.establishmentName.toLowerCase().contains(query.toLowerCase()) ||
            establishment.establishmentAddress.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }


  // This is for the update of the establishment
  void updateEstablishment(Map<String, dynamic> data, BuildContext context) {
    if (shelterNameController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the name of the shelter');
    } else if (shelterDescriptionController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the description of the shelter');
    } else if (shelterAddressController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the address of the shelter');
    } else if (shelterPhoneNumber.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the phone number of the shelter');
    } else if (shelterEmailController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please enter the email of the shelter');
    } else if (shelterImage.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Please select an image for the shelter');
    } else if (selectedLocation == null) {
      ToastComponent().showMessage(Colors.red, 'Please select the location of the shelter');
    } else {
      _addLocationRespository.updateLocation(data, context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // This is for the delete data
  void deleteEstablishment(String id, BuildContext context) {
    _addLocationRespository.deleteEstablishment(id, context);
    notifyListeners();
  }

  void updateProfileData(BuildContext context, String id) {
    if (selectedImage.isNotEmpty) {
      _addLocationRespository.updateProfileImage(selectedImage, id, context);
    } else {
      ToastComponent().showMessage(Colors.red, 'Please select an image');
    }

  }
}