import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/model/DonationModel.dart';
import 'package:pet_welfrare_ph/src/respository/DonationRepository.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DonateViewModel extends ChangeNotifier {

  TextEditingController amount = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String transactionPath='';

  final DonationRepository _donationRepository = DonationRepositoryImpl();

  List<String> donationType = ['Bank Transfer','Cash', 'Non-Cash/In-Kind'];
  String? selectedDonationType = 'Cash';

  List<DonationModel> donationList = [];

  // Fetch the donation list
  final StreamController<List<DonationModel>> _donationStreamController =
  StreamController<List<DonationModel>>();

  // Expose the stream
  Stream<List<DonationModel>> get donationStream =>
      _donationStreamController.stream;


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
    String amountValue = amount.text;
    String dateValue = dateController.text;
    String timeValue = timeController.text;
    if(selectedDonationType == 'Cash' || selectedDonationType == 'Bank Transfer') {
      if (amountValue.isNotEmpty && dateValue.isNotEmpty &&
          timeValue.isNotEmpty) {
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Submitting...');
        try {
          var donation = {
            'amount': amountValue,
            'date': dateValue,
            'time': timeValue,
            'donationType': selectedDonationType,
            'postId': postId,
            'transactionPath': transactionPath,
          };
          _donationRepository.submitDonation(donation);
          Navigator.of(context).pop();
        } catch (e) {
          print(e);
        }
        finally {
          pd.close();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the fields'),
          ),
        );
      }
    } else{
      if (dateValue.isNotEmpty && timeValue.isNotEmpty && transactionPath.isNotEmpty) {
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Submitting...');
        try {
          var donation = {
            'amount': 'n/a',
            'date': dateValue,
            'time': timeValue,
            'donationType': selectedDonationType,
            'postId': postId,
            'transactionPath': transactionPath,
          };
          _donationRepository.submitDonation(donation);
          Navigator.of(context).pop();
        } catch (e) {
          print(e);
        }
        finally {
          pd.close();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the fields'),
          ),
        );
      }
    }

  }

  void setselectedDonation(String? newValue) {
    selectedDonationType = newValue;
    notifyListeners();
  }

  // Initialize the donation stream
  void initializeDonationStream(String postId) {
    _donationRepository.getDonationList(postId).listen((donations) {
      donationList = donations;
      _donationStreamController.add(donations);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _donationStreamController.close();
    super.dispose();
  }


}