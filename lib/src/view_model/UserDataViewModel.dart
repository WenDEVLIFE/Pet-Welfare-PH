import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/respository/LoadProfileRespository.dart';
import '../utils/SessionManager.dart';

class UserDataViewModel extends ChangeNotifier {
  final List<String> idType1 = [
    'Passport', 'Driver\'s License', 'SSS ID', 'UMID', 'Voter\'s ID', 'Postal ID', 'PRC ID',
    'OFW ID', 'Senior Citizen ID', 'PWD ID', 'Student ID', 'Company ID', 'Police Clearance',
    'NBI Clearance', 'Barangay Clearance', 'Health Card', 'PhilHealth ID', 'TIN ID', 'GSIS ID',
    'Pag-IBIG ID', 'DFA ID', 'National ID',
  ];

  final ImagePicker imagePicker = ImagePicker();
  String frontImagePath = '';
  String backImagePath = '';

  String name = '';
  String email = '';
  String idType = '';
  String profilepath = '';
  String idfrontpath = '';
  String idbackpath = '';
  String role = '';
  String address = '';
  String id = '';
  String status = '';
  String selectedIdType = '';

  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final sessionManager = SessionManager();

  Future<void> loadInformation() async {
    final Map<String, dynamic>? userData = await _loadprofilerespository.loadProfile1();
    name = userData?['name'] ?? '';
    email = userData?['email'] ?? '';
    idType = userData?['idType'] ?? '';
    profilepath = userData?['profilepath'] ?? '';
    idfrontpath = userData?['idfrontpath'] ?? '';
    idbackpath = userData?['idbackpath'] ?? '';
    role = userData?['role'] ?? '';
    address = userData?['address'] ?? '';
    status = userData?['status'] ?? '';
    selectedIdType = idType.isNotEmpty ? idType : (idType1.isNotEmpty ? idType1.first : '');
    notifyListeners();
  }

  Future<void> pickImage(bool isFront) async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isFront) {
        frontImagePath = pickedFile.path;
      } else {
        backImagePath = pickedFile.path;
      }
      notifyListeners();
    }
  }

  void loadSelectedIDType() {
    selectedIdType = idType;
    notifyListeners();
  }

  void updateIdType(String newValue) {
    selectedIdType = newValue;
    notifyListeners();
  }
}