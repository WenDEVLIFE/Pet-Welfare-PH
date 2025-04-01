import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DonateViewModel extends ChangeNotifier {

  TextEditingController amount = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String transactionPath='';

  // Select a transaction date
  void selectDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      dateController.text = date.toLocal().toString().split(' ')[0];
      notifyListeners();
    }
  }

  void selectTime(BuildContext context) async{
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay? time) {
      if (time != null) {
        timeController.text = time.format(context);
        notifyListeners();
      }
    });
  }

  // Pick the transaction image
  Future <void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      transactionPath = image.path;
      notifyListeners();
    }
  }

  void submitDonation(String postId, BuildContext context) {

  }



}