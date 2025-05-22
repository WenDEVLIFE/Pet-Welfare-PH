
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

import '../view_model/ReportViewModel.dart';
import 'package:provider/provider.dart';

import '../widgets/CustomButton.dart';

class ReportDialog extends StatelessWidget {
  final String postId;

  ReportDialog(this.postId);


  @override
  Widget build(BuildContext context) {

  final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ReportViewModel>(builder: (context, reportViewModel, child) {
        return AlertDialog(
          title:  CustomText(
            text: 'Report Post',
            size:  25,
            color: AppColors.black  ,
            weight: FontWeight.w600,
            align: TextAlign.start,
            screenHeight: screenHeight,
            alignment: Alignment.centerLeft,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                  text: 'Please provide a reason for reporting this post.',
                  size:  16,
                  color: AppColors.black  ,
                  weight: FontWeight.w600,
                  align: TextAlign.start,
                  screenHeight: screenHeight,
                  alignment: Alignment.centerLeft,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: reportViewModel.reasonController,
                decoration: const InputDecoration(
                  hintText: 'Enter reason',
                ),
              ),
              CustomText(
                text: 'Select a file to upload',
                size:  16,
                color: AppColors.black  ,
                weight: FontWeight.w600,
                align: TextAlign.start,
                screenHeight: screenHeight,
                alignment: Alignment.centerLeft,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: reportViewModel.filePath.isEmpty
                        ? Image.asset(
                      'assets/images/cat.jpg',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      File(reportViewModel.filePath),
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: CustomButton(
                  hint: 'Upload Image',
                  size: 16,
                  color1: AppColors.orange,
                  textcolor2: AppColors.white,
                  onPressed: () {
                    reportViewModel.picImagePicker();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                reportViewModel.submitReport(postId,context);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

  }

}