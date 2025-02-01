import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/YahooServices.dart';

class OTPViewModel extends ChangeNotifier {
  int time = 60;
  Timer? _timer;
  int otp = 0;
  bool _isLoading = false;

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void generateOTP(BuildContext context) {
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
    YahooMail().sendEmail(otp, "medinajrfrouen@gmail.com", setLoading, context);
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

  void checkOTP(int enteredOTP) {
    String enteredOTP = controllers.map((controller) => controller.text).join();
    if (enteredOTP == otp.toString()) {
      if (kDebugMode) {
        print('OTP is correct');
      }
    } else {
      if (kDebugMode) {
        print('OTP is incorrect');
      }
    }
  }

  void clearData() {
    for (var controller in controllers) {
      controller.clear();
    }
  }

}