import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class Alertmenudialog extends StatelessWidget {
  final VoidCallback onAction;
  final String title;
  final String content;

  Alertmenudialog({required this.onAction , required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orange,
      title: Text(title,
        style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'SmoochSans',
        fontWeight: FontWeight.w600,
      ),),
      content:  Text(content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w400,
        ),),
      actions: <Widget>[
        TextButton(
          child: const Text('No', style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes', style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),),
          onPressed: () {
            onAction();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}