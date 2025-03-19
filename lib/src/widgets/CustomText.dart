import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;
  final double screenHeight;
  final Alignment alignment;

  const CustomText({
    required this.text,
    required this.size,
    required this.color,
    required this.weight,
    required this.align,
    required this.screenHeight,
    required this.alignment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenHeight < 600 ? const EdgeInsets.all(5) : const EdgeInsets.all(10),
    child:Align(
      alignment: alignment,
      child:  Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          fontFamily: 'SmoochSans',
        ),
      ),
    )
    );
  }
}