import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/AddUserRespository.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class ChangeProfileDialog extends StatefulWidget {
  const ChangeProfileDialog({Key? key}) : super(key: key);

  @override
  ProfileDialogState createState() => ProfileDialogState();
}

class ProfileDialogState extends State<ChangeProfileDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    return AlertDialog(
      backgroundColor: AppColors.orange,
      title: const Text(
        'Change Profile Picture',
        style: TextStyle(
          color: AppColors.white,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please provide a reason for banning the user:',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(
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
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (reasonController.text.isNotEmpty) {

            }
          },
          child: const Text(
            'Confirm Ban',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}