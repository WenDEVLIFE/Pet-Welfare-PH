import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  LogoutDialog({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orange,
      title: const Text('Logout', style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'SmoochSans',
        fontWeight: FontWeight.w600,
      ),),
      content: const Text('Are you sure you want to logout?',
        style: TextStyle(
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
            onLogout();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}