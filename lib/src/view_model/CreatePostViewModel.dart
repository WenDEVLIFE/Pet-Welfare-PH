import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'dart:io';

import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreatePostViewModel extends ChangeNotifier {
  final TextEditingController postController = TextEditingController();
  final List<File> _images = [];
  var chipLabels1 = [
    'Pet Appreciation','Paw-some Experience', 'Protect Our Pets: Report Abuse', 'Caring for Pets: Vet & Travel Insights'
  ];

  final PostRepository postRepository = PostRepositoryImpl();

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

  void clearPost() {
    postController.clear();
    _images.clear();
    selectedChip = 'Pet Appreciation';
    notifyListeners();
  }

  Future<void> PostNow(BuildContext context) async {

    if (postController.text.isEmpty) {
      // Implement post functionality here
      ToastComponent().showMessage(Colors.red, 'Post cannot be empty');
    }

    else if (_images.isEmpty) {
      // Implement post functionality here
      ToastComponent().showMessage(Colors.red, 'Please select an image');
    }

    else {
      // Implement post functionality here
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Posting...');
       try{
         await postRepository.uploadPost(postController.text, _images, selectedChip);
         ToastComponent().showMessage(Colors.green, 'Post successful');
         clearPost();
       }
        catch(e){
          ToastComponent().showMessage(Colors.red, 'Failed to upload post: $e');
        }
        finally{
          pd.close();
        }
    }
  }
}