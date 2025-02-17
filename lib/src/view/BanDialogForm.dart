import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class BanDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orange,
      title: const Text('Ban User', style: TextStyle(
        color: AppColors.white,
        fontFamily: 'SmoochSans',
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please provide a reason for banning the user:' , style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),),
          TextField(
            decoration: InputDecoration(
              labelText: 'Reason',
              labelStyle: TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              hintText: 'Enter reason here',
              hintStyle: TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel' , style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),),
        ),
        TextButton(
          onPressed: () {
            // Implement the ban functionality here
            Navigator.of(context).pop();
          },
          child: const Text('Confirm Ban' , style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),),
        ),
      ],
    );
  }
}