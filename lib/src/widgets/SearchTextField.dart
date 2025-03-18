import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final double screenHeight;
  final String hintText;
  final double fontSize;
  final TextInputType keyboardType;
  final Function(String)? onChanged; // Added optional callback

  const CustomSearchTextField({
    Key? key,
    required this.controller,
    required this.screenHeight,
    required this.hintText,
    required this.fontSize,
    required this.keyboardType,
    this.onChanged, // Optional function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenHeight * 0.02,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // Use callback if provided
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          hintText: hintText, // Use dynamic hint text
          hintStyle: const TextStyle(color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        ),
        style: TextStyle(
          fontFamily: 'SmoochSans',
          color: Colors.black,
          fontSize: fontSize, // Use dynamic font size
          fontWeight: FontWeight.w600,
        ),
        keyboardType: keyboardType, // Use dynamic keyboard type
      ),
    );
  }
}
