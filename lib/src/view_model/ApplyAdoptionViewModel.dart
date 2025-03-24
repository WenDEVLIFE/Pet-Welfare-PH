import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/respository/UserRepository.dart';
import 'package:pet_welfrare_ph/src/services/LocationService.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import '../model/BarangayModel.dart';
import '../model/CityModel.dart';
import '../model/ProvinceModel.dart';
import '../model/RegionModel.dart';

class ApplyAdoptionViewModel extends ChangeNotifier {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController facebookUsernameController = TextEditingController();

  UserRepository userRepository = UserRepositoryImpl();

  var adoptionType = ['Adoption', 'Foster'];

  String selectedAdoptionType = 'Adoption';

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


  LocationService locationService = LocationService();

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

  void setSelectedAdoptionType(String adoptionType) async {
    selectedAdoptionType = adoptionType;
    notifyListeners();
  }

  Future<void> submitAdoptionForm(String postId) async {
    // Handle form submission logic
    final name = nameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final address = addressController.text;
    final adoptionType = selectedAdoptionType;

    // Perform form validation and submission
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Address: $address');
    print('Adoption Type: $adoptionType');

    bool checkEmail = await userRepository.checkValidateEmail(email);
    bool checkPhone = await userRepository.checkPhoneNumber(phone);

    if(name.isEmpty){
      ToastComponent().showMessage(Colors.red, "Name is required");
    }

    if (email.isEmpty) {
      ToastComponent().showMessage(Colors.red, "Email is required");
    }
    if (phone.isEmpty) {
      ToastComponent().showMessage(Colors.red, "Phone is required");
    }

    if (!checkEmail) {
      ToastComponent().showMessage(Colors.red, "Email is invalid");
    }

    if (!checkPhone) {
      ToastComponent().showMessage(Colors.red, "Phone is invalid");
    }

    if (selectedRegion == null) {
      ToastComponent().showMessage(Colors.red, "Region is required");
    }

    if (selectedProvince == null) {
      ToastComponent().showMessage(Colors.red, "Province is required");
    }

    if (selectedCity == null) {
      ToastComponent().showMessage(Colors.red, "City is required");
    }

    if (selectedBarangay == null) {
      ToastComponent().showMessage(Colors.red, "Barangay is required");
    }

    if (address.isEmpty) {
      ToastComponent().showMessage(Colors.red, "Address is required");
    }

    else{

      var applyForm = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "adoptionType": adoptionType,
        "region": selectedRegion!.region,
        "province": selectedProvince!.provinceName,
        "city": selectedCity!.cityName,
        "barangay": selectedBarangay!.barangayName,
        "postId": postId
      };
    }

  }

  Future<String> loadReminders() async {
    // Load text from the text file
    String text = await rootBundle.loadString("assets/word/reminders.txt");
    return text;
  }

  void showReminders(BuildContext context) async {
    String termsText = await loadReminders();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reminders"),
          content: SingleChildScrollView(
            child: Text(termsText, textAlign: TextAlign.justify),
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

}