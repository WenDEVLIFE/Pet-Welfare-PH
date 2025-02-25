import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:provider/provider.dart';

import '../utils/ImageUtils.dart';
import '../utils/ToastComponent.dart';
import '../view_model/ShelterClinicViewModel.dart';

class ChangeEstablishmentProfile extends StatelessWidget {
  final String id; // Add this line to store the ID
  const ChangeEstablishmentProfile(this.id, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Consumer<ShelterClinicViewModel>(builder: (context, viewModel, child) {
      return AlertDialog(
        backgroundColor: AppColors.orange,
        title: const Text(
          'Change Establishment Picture',
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
              'Select a new picture',
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
                  Consumer<ShelterClinicViewModel>(
                    builder: (context, viewModel, child) {
                      return buildProfileImage(viewModel);
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
                        icon: const Icon(Icons.photo_camera, color: AppColors.white,),
                        onPressed: () =>
                            context.read<ShelterClinicViewModel>().pickImageCamera(),
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
              Provider.of<ShelterClinicViewModel>(context, listen: false).updateProfileData(context, id);
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

  Widget buildProfileImage(ShelterClinicViewModel viewModel) {
    ImageProvider? imageProvider;

    try {
      if (viewModel.selectedImage.isNotEmpty) {
        // If selectedImage is a file path, check if the file exists
        File file = File(viewModel.selectedImage);
        if (file.existsSync()) {
          imageProvider = FileImage(file);
        } else {
          print("File does not exist: ${viewModel.selectedImage}");
          imageProvider = const AssetImage(ImageUtils.catPath);
        }
      } else if (viewModel.isNetworkImage && viewModel.shelterImage.isNotEmpty) {
        // If no selectedImage but it's a network image, load from network
        imageProvider = NetworkImage(viewModel.shelterImage);
      } else {
        // Fallback to default asset image
        imageProvider = const AssetImage(ImageUtils.catPath);
      }
    } catch (e) {
      print('Error loading image: $e');
      imageProvider = const AssetImage(ImageUtils.catPath);
    }

    return CircleAvatar(
      radius: 100,
      backgroundColor: AppColors.orange,
      child: CircleAvatar(
        radius: 95,
        backgroundImage: imageProvider,
        onBackgroundImageError: (exception, stackTrace) {
          print('Image load error: $exception');
          ToastComponent().showMessage(Colors.red, 'Error loading image');
        },
      ),
    );
  }

}