import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../view_model/DonateViewModel.dart';
import '../widgets/CustomText.dart';

/// TODO: implement the ui
class ViewDonationModal extends StatelessWidget{

  String postId;

  ViewDonationModal({ Key? key, required this.postId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    DonateViewModel donateViewModel = Provider.of<DonateViewModel>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      donateViewModel.initializeDonationStream(postId);
    });

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
                'List of Donations',
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
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<DonateViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.donationList.isEmpty) {
                  return const Center(child: Text('No donations found.'));
                }

                return ListView.builder(
                  itemCount: viewModel.donationList.length,
                  itemBuilder: (context, index) {
                    final donations = viewModel.donationList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:  "Donator Name:",
                                    size: 20,
                                    color: AppColors.black,
                                    weight: FontWeight.w700,
                                    align: TextAlign.left,
                                    screenHeight: screenHeight,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  CustomText(
                                    text:    donations.donationname,
                                    size: 16,
                                    color: AppColors.black,
                                    weight: FontWeight.w700,
                                    align: TextAlign.left,
                                    screenHeight: screenHeight,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  ExpansionTile(
                                    iconColor: AppColors.black,
                                    collapsedIconColor: AppColors.black,
                                    textColor: AppColors.black,
                                    leading: const Icon(Icons.pets),
                                    title: CustomText(
                                      text: 'Donator Details',
                                      size: 24,
                                      color: AppColors.black,
                                      weight: FontWeight.w700,
                                      align: TextAlign.left,
                                      screenHeight: screenHeight,
                                      alignment: Alignment.centerLeft,
                                    ),
                                    initiallyExpanded: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          CustomText(
                                              text: 'Donation Type:',
                                              size: 20,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
                                              align: TextAlign.left,
                                              screenHeight: screenHeight,
                                              alignment: Alignment.centerLeft,
                                            ),
                                            CustomText(
                                              text: donations.donationType,
                                              size: 16,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
                                              align: TextAlign.left,
                                              screenHeight: screenHeight,
                                              alignment: Alignment.centerLeft,
                                            ),
                                             if(donations.donationType =='Bank Transfer' || donations.donationType == 'Cash') ... [
                                               CustomText(
                                                 text: 'Estimated Amount:',
                                                 size: 20,
                                                 color: AppColors.black,
                                                 weight: FontWeight.w700,
                                                 align: TextAlign.left,
                                                 screenHeight: screenHeight,
                                                 alignment: Alignment.centerLeft,
                                               ),
                                             ],
                                            CustomText(
                                              text: donations.amount,
                                              size: 16,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
                                              align: TextAlign.left,
                                              screenHeight: screenHeight,
                                              alignment: Alignment.centerLeft,
                                            ),
                                            CustomText(
                                              text: 'Time of Donation:',
                                              size: 20,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
                                              align: TextAlign.left,
                                              screenHeight: screenHeight,
                                              alignment: Alignment.centerLeft,
                                            ),
                                            CustomText(
                                              text: donations.time,
                                              size: 16,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
                                              align: TextAlign.left,
                                              screenHeight: screenHeight,
                                              alignment: Alignment.centerLeft,
                                            ),
                                            CustomText(
                                              text: 'Transaction Image',
                                              size: 20,
                                              color: AppColors.black,
                                              weight: FontWeight.w700,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    // Handle delete action
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );

  }

}