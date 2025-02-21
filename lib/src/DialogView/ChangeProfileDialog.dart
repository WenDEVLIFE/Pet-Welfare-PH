import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/UserDataViewModel.dart';
import 'package:provider/provider.dart';

class ChangeProfileDialog extends StatelessWidget {
  const ChangeProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer(builder: (context, UserDataViewModel viewModel, child) {
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
              'Select a new profile picture',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Stack(
                children: [
                  Consumer<UserDataViewModel>(
                    builder: (context, viewModel, child) {
                      return CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.orange,
                        child: CircleAvatar(
                          radius: 95,
                          backgroundImage: viewModel.selectedProfilePath.isNotEmpty
                              ? FileImage(File(viewModel.selectedProfilePath))
                              : viewModel.selectedProfilePath.isNotEmpty
                              ? NetworkImage(viewModel.profilepath) as ImageProvider<Object>?
                              : null,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: () =>
                            context.read<UserDataViewModel>().pickSelectProfileImage(),
                      ),
                    ),
                  ),
                ],
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
              // Add your update profile logic here
            },
            child: const Text(
              'Update Profile',
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
    });
  }
}