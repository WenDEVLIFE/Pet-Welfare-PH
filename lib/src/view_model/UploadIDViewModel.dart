import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/helpers/Route.dart';

class UploadIDViewModel extends ChangeNotifier {
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

  void navigateToOTP(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.otpScreen);
  }
}