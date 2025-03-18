import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double screenHeight;
  final String hintText;
  final double fontSize;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.screenHeight,
    required this.hintText,
    required this.fontSize,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.gray,
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: fontSize, // Use dynamic font size
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize, // Use dynamic font size
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
