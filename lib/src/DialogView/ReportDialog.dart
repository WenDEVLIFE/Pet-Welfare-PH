
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

import '../view_model/ReportViewModel.dart';
import 'package:provider/provider.dart';

class ReportDialog extends StatelessWidget {
  ReportDialog(String postId);

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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                reportViewModel.submitReport();
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