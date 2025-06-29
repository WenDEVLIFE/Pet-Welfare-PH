import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/services/LocationService.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';

import '../model/BarangayModel.dart';
import '../model/BreedModel.dart';
import '../model/CityModel.dart';
import '../model/ProvinceModel.dart';
import '../model/RegionModel.dart';
import '../services/PetAPI.dart';
import  'package:provider/provider.dart';

class SearchPetViewModel extends ChangeNotifier {

  List<String> colorpatter = [];
  String? selectedColor;

  List<String> petSize = [];
  String? selectedPetSize;

  List<Breed> catBreeds = [];
  Breed? selectedCatBreed;

  List<Breed> dogBreeds = [];
  Breed? selectedDogBreed;

  List<String> petAgeList = [];
  String? selectedPetAge;

  List <String> petGender = [];
  String? selectedPetGender;

  List<String> adoptionStatus = [];
  String? selectedAdoptionStatus;

  List<String> SearchType = [
    'Pet Adoption',
    'Found Pets',
    'Missing Pets',
    'Pets For Rescue',
    'Pet Care Insights'
  ];
  String? selectedSearchType = 'Pet Adoption';

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

  List<String> petTypes = [];
  String? selectedPetType;

  List<String> collarList = [];
  String? selectedCollar;

  final TextEditingController petnameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  final LocationService locationService = LocationService();

  SearchPetViewModel() {
    loadPetAdoption();
    fetchRegions();
    fetchCatBreeds();
    fetchDogBreeds();
  }

  // This will load the color
  Future <void> loadPetAdoption() async {
    if (colorpatter.isEmpty) {
      colorpatter = [
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
    }

    if (petAgeList.isEmpty) {
      petAgeList = [
        '1 month',
        '2 months',
        '3 months',
        '4 months',
        '5 months',
        '6 months',
        '7 months',
        '8 months',
        '9 months',
        '10 months',
        '11 months',
        '1 year',
        '2 years',
        '3 years',
        '4 years',
        '5 years',
        '6 years',
        '7 years',
        '8 years',
        '9 years',
        '10 years',
        '11 years',
        '12 years',
        '13 years',
        '14 years',
        '15 years',
        '16 years',
        '17 years',
        '18 years',
        '19 years',
        '20 years',
        '21 years',
        '22 years',
        '23 years',
        '24 years',
        '25 years',
        '26 years',
        '27 years',
        '28 years',
        '29 years',
        '30 years',
        '31 years',
        '32 years',
        '33 years',
        '34 years',
        '35 years'
      ];
    }

    if (petSize.isEmpty) {
      petSize = ['Tiny', 'Small', 'Medium', 'Large'];
    }

    if (petGender.isEmpty) {
      petGender = ['Male', 'Female', 'Can’t determine (for found pets)'];
    }

    if (adoptionStatus.isEmpty) {
      adoptionStatus = ['Ongoing', 'Paused', 'FullFilled'];
    }

    if (petTypes.isEmpty) {
      petTypes = ['Cat', 'Dog', 'Others (for birds, reptiles, etc.)'];
    }

    if (collarList.isEmpty) {
      collarList = ['With Collar', 'Without Collar'];
    }
    notifyListeners();
  }

  void setPetType(String? newValue) {
    selectedPetType = newValue;
    notifyListeners();
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

  // This is for the cat breed
  void selectedCatBreed1(Breed? newValue) {
    selectedCatBreed = newValue;
    notifyListeners();
  }

  // This is for the dog breed
  void selectedDogBreed2(Breed? newValue) {
    selectedDogBreed = newValue;
    notifyListeners();
  }


  // This is for the color or pattern
  void setColor(String? newValue) {
    selectedColor = newValue!;
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

  void setSearchType(String? newValue) {
    selectedSearchType = newValue!;
    notifyListeners();
  }

  // for searching
  void search(context) async {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    Map <String, dynamic> searchParams = {
      'region': selectedRegion?.region.toString().toLowerCase(),
      'province': selectedProvince?.provinceName.toString().toLowerCase(),
      'city': selectedCity?.cityName.toString().toLowerCase(),
      'barangay': selectedBarangay?.barangayName.toString().toLowerCase(),
      'petName': petnameController.text.toLowerCase(),
      'petType': selectedPetType?.toLowerCase(),
      'dogBreed': selectedDogBreed?.name.toLowerCase(),
      'catBreed': selectedCatBreed?.name.toLowerCase(),
      'petGender': selectedPetGender?.toLowerCase(),
      'petSize': selectedPetSize?.toLowerCase(),
      'address': addressController.text.toLowerCase(),
      'colorPattern': selectedColor?.toLowerCase(),
    };

    if (selectedSearchType == 'Pet Adoption') {
      if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
        return;
      }

      if (selectedPetType == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet type');
        return;
      }
      if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
        return;
      }

      if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
        return;
      }

      if (selectedPetSize == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet size');
        return;
      }

      if (selectedPetGender == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet gender');
        return;
      }

      if (selectedColor == null) {
        ToastComponent().showMessage(
            Colors.red, 'Please select a color or pattern');
        return;
      }

      if (addressController.text.isEmpty) {
        ToastComponent().showMessage(Colors.red, 'Please enter a address');
        return;
      }

      await postViewModel.startSearchPetAdoption(searchParams);
    }
    else if (selectedSearchType == 'Found Pets') {
      if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
        return;
      }

      if (selectedPetType == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet type');
        return;
      }
      if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
        return;
      }

      if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
        return;
      }

      if (selectedPetSize == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet size');
        return;
      }

      if (selectedPetGender == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet gender');
        return;
      }

      if (selectedColor == null) {
        ToastComponent().showMessage(
            Colors.red, 'Please select a color or pattern');
        return;
      }
      await postViewModel.startSearchFoundPets(searchParams);
    }
    else if (selectedSearchType == 'Missing Pets') {
      if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
        return;
      }

      if (selectedPetType == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet type');
        return;
      }
      if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
        return;
      }

      if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
        return;
      }

      if (selectedPetSize == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet size');
        return;
      }

      if (selectedPetGender == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet gender');
        return;
      }

      if (selectedColor == null) {
        ToastComponent().showMessage(
            Colors.red, 'Please select a color or pattern');
        return;
      }
      await postViewModel.startSearchMissingPets(searchParams);
    }
    else if (selectedSearchType == 'Pets For Rescue') {
      if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
        return;
      }

      if (selectedPetType == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet type');
        return;
      }
      if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
        return;
      }

      if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
        return;
      }

      if (selectedPetSize == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet size');
        return;
      }

      if (selectedPetGender == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a pet gender');
        return;
      }

      if (selectedColor == null) {
        ToastComponent().showMessage(
            Colors.red, 'Please select a color or pattern');
        return;
      }

      await postViewModel.startSearchPetsForRescue(searchParams);
    }

    else if (selectedSearchType == 'Pet Care Insights') {
      if (selectedRegion == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a region');
        return;
      }

      if (selectedProvince == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a province');
        return;
      }

      if (selectedCity == null) {
        ToastComponent().showMessage(Colors.red, 'Please select a city');
        return;
      }

      await postViewModel.startSearchPetCareInsights(searchParams);
    }
    else {
      ToastComponent().showMessage(Colors.red, 'Please select a search type');
    }

    notifyListeners();
  }

  void setDogBreed(Breed? newValue) {
    selectedDogBreed = newValue;
    notifyListeners();
  }

  void setCatBreed(Breed? newValue) {
    selectedCatBreed = newValue;
    notifyListeners();
  }


}