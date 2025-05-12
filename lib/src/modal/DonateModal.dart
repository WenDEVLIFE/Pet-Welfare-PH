import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/DonateViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomDropdown.dart';
import '../widgets/CustomTextField.dart';

class DonateModal extends StatelessWidget {
  final String postId;
  DonateModal(this.postId);

  @override
  Widget build(BuildContext context) {
    final DonateViewModel viewModel = Provider.of<DonateViewModel>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Submit Donation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Donators Name',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: viewModel.nameController,
                    screenHeight: screenHeight,
                    hintText: 'Enter donators name...',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  CustomText(
                    text: 'Type of Donation',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomDropDown<String?>(
                    value: viewModel.selectedDonationType,
                    items: viewModel.donationType,
                    onChanged: (String? newValue) {
                      viewModel.setselectedDonation(newValue);
                    },
                    itemLabel: (String? value) => value!,
                    hint: 'Select a Donation Type',
                  ),
                 if(viewModel.selectedDonationType?.toLowerCase()=='cash' || viewModel.selectedDonationType?.toLowerCase()=='bank transfer' )...[
                   CustomText(
                     text: 'Amount Donated',
                     size: 25,
                     color: AppColors.black,
                     weight: FontWeight.w600,
                     align: TextAlign.left,
                     screenHeight: screenHeight,
                     alignment: Alignment.centerLeft,
                   ),
                   SizedBox(height: screenHeight * 0.01),
                   CustomTextField(
                     controller: viewModel.amount,
                     screenHeight: screenHeight,
                     hintText: 'Enter donation amount...',
                     fontSize: 16,
                     keyboardType: TextInputType.number,
                   ),
                 ],
                  CustomText(
                    text: 'Date of Donation',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: viewModel.dateController,
                      readOnly: true,
                      onTap: () async {
                        viewModel.selectDate(context);
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a date of the donation...',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'Time of Donation',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: viewModel.timeController,
                      readOnly: true,
                      onTap: () async {
                        viewModel.selectTime(context);
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a time of the donation...',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'Transaction Image',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: viewModel.transactionPath.isEmpty
                            ? Image.asset(
                          'assets/images/cat.jpg',
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.4,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          File(viewModel.transactionPath),
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
                      hint: viewModel.donationType.contains('Cash') ? 'Upload Transaction Image' : 'Upload Transaction Image',
                      size: 16,
                      color1: AppColors.orange,
                      textcolor2: AppColors.white,
                      onPressed: () {
                        viewModel.pickImage();
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: CustomButton(
                      hint: 'Submit Donation',
                      size: 16,
                      color1: AppColors.orange,
                      textcolor2: AppColors.white,
                      onPressed: () {
                        viewModel.submitDonation(postId, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}