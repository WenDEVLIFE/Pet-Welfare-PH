import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class MenuViewModel extends ChangeNotifier {
  final ImagePicker imagePicker = ImagePicker();
  String currentfilepath = '';

  Future<void> pickImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      currentfilepath = pickedFile.path;
      notifyListeners();
    }
  }

}