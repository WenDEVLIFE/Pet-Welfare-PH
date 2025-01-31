
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class OTPField extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OTPField({Key? key, required this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return _buildOTPField(context, index);
      }),
    );
  }

  Widget _buildOTPField(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(5),
      ),
      width: 40,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Add this line
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  void OTPVerification(int otp, BuildContext context, Map<String, dynamic> extra) {
    String enteredOTP = controllers.map((controller) => controller.text).join();
    if (enteredOTP == otp.toString()) {
      print('OTP is correct');

    } else {

    }
  }
  void clearData() {
    for (var controller in controllers) {
      controller.clear();
    }
  }
}