import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final String hint;
   final double size;
    final Color color1;
   final Color textcolor2;
    final VoidCallback onPressed;

    CustomButton({
      required this.hint,
      required this.size,
      required this.color1,
      required this.textcolor2,
      required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      ),
      child:  Text(
        hint,
        style: TextStyle(
          color: textcolor2,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

}