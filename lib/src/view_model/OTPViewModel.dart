import 'dart:async';
import 'package:flutter/cupertino.dart';

class OTPViewModel extends ChangeNotifier {
  int time = 60;
  Timer? _timer;
  int otp = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void generateOTP() {
    int min = 234563;
    int max = 999999;
    otp = min + (DateTime.now().millisecond % (max - min));
    print('OTP: $otp');
    // Send the OTP via email
    // YahooMail().sendEmail(otp, email, setLoading, context);
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
}