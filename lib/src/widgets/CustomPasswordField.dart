import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class CustomPasswordField extends StatelessWidget {
  final double screenHeight;
  final String hintText;
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;

  const CustomPasswordField({
    required this.screenHeight,
    required this.hintText,
    required this.controller,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            togglePasswordVisibility();
          },
        ),
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'SmoochSans',
        ),
      ),
      obscureText:!isPasswordVisible,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}