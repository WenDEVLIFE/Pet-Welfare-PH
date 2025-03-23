import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/services/YahooServices.dart';

import '../respository/UserRepository.dart';

class OTPViewModel extends ChangeNotifier {
  int time = 60;
  Timer? _timer;
  int otp = 0;
  bool _isLoading = false;

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  final UserRepository _repository = UserRepositoryImpl();

  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void generateOTP(BuildContext context, String email) {
    int min = 234563;
    int max = 999999;
    otp = min + (DateTime.now().millisecond % (max - min));
    if (kDebugMode) {
      print('OTP: $otp');

      Fluttertoast.showToast(
        msg: 'OTP: $otp',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // Send the OTP via email
    YahooMail().sendEmail(otp, email, setLoading, context);
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time > 0) {
        time--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    time = 60;
    notifyListeners();
  }

  void checkOTP(int enteredOTP, Map<String, dynamic>? userData, BuildContext context) {
    if (userData != null) {
      userData.addAll({'address': otp});
      String enteredOTP = controllers.map((controller) => controller.text).join();
      if (enteredOTP == otp.toString()) {
        // Register user
        _repository.registerUser(userData, context, clearData);
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid OTP',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      }
    } else {
      Fluttertoast.showToast(
        msg: 'User data is null',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }

  void clearData() {
    for (var controller in controllers) {
      controller.clear();
      notifyListeners();
    }
  }

}