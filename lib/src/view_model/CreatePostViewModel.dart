import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final List<File> _images = [];
  var chipLabels1 = [
    'Pet Appreciation','Paw-some Experience', 'Protect Our Pets: Report Abuse', 'Caring for Pets: Vet & Travel Insights'
  ];
  String selectedChip = 'Pet Appreciation';

  List<File> get images => _images;

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
}