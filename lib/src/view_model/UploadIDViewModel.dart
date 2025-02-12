import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

class UploadIDViewModel extends ChangeNotifier {
  final List<String> idType = [
    'Passport', 'Driver\'s License', 'SSS ID', 'UMID', 'Voter\'s ID', 'Postal ID', 'PRC ID',
    'OFW ID', 'Senior Citizen ID', 'PWD ID', 'Student ID', 'Company ID', 'Police Clearance',
    'NBI Clearance', 'Barangay Clearance', 'Health Card', 'PhilHealth ID', 'TIN ID', 'GSIS ID',
    'Pag-IBIG ID', 'DFA ID'
  ];

  String selectedIdType = 'Passport';

  void updateIdType(String newValue) {
    selectedIdType = newValue;
    notifyListeners();
  }

  final ImagePicker imagePicker = ImagePicker();
  String frontImagePath = '';
  String backImagePath = '';

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

  void navigateToOTP(BuildContext context, Map<String, dynamic> userData1) {
     if (frontImagePath.isNotEmpty && backImagePath.isNotEmpty) {
       var email = userData1['email']!;
        var password = userData1['password']!;
        var name = userData1['name']!;
        var role = userData1['role']!;

       Navigator.pushNamed(context, AppRoutes.otpScreen, arguments: {
         'email': email,
         'password': password,
         'name': name,
         'role': role,
         'idback': backImagePath,
         'idfront': frontImagePath,
       });
     }

  }
}
