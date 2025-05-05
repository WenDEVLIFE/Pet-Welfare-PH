import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/ApplyAdoptionViewModel.dart';

import '../utils/AppColors.dart';
import '../widgets/CustomText.dart';

class ViewAdoptionModal extends StatelessWidget {
  final String postId;
  const ViewAdoptionModal({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Trigger data fetch when the modal is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplyAdoptionViewModel>(context, listen: false).getPetAdoption(postId);
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
                'List of Adoptions',
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
            child: Consumer<ApplyAdoptionViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.adoptions.isEmpty) {
                  return const Center(child: Text('No adoptions found.'));
                }

                return ListView.builder(
                  itemCount: viewModel.adoptions.length,
                  itemBuilder: (context, index) {
                    final adoptionDetails = viewModel.adoptions[index];

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
                                Text(
                                  adoptionDetails.adoptionName,
                                  style: const TextStyle(
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  adoptionDetails.adoptionType,
                                  style: const TextStyle(
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ExpansionTile(
                                  title: CustomText(
                                    text:  adoptionDetails.adoptionType =='Foster' ? 'Foster Details' : 'Adoption Details',
                                    size: 24,
                                    color: AppColors.black,
                                    weight: FontWeight.w700,
                                    align: TextAlign.left,
                                    screenHeight: screenHeight,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: 'Facebook Username:',
                                            size: 20,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: adoptionDetails.facebookUsername,
                                             size: 16,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: 'Email Address:',
                                            size: 20,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: 'Phone Number:',
                                            size: 20,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: adoptionDetails.phoneNum,
                                            size: 16,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: adoptionDetails.email,
                                            size: 16,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: 'Address:',
                                            size: 20,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: '${adoptionDetails.address}',
                                            size: 16,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: 'Region/Province/City/Barangay:',
                                            size: 20,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          CustomText(
                                            text: '${adoptionDetails.region}, ${adoptionDetails.province}, ${adoptionDetails.city}, ${adoptionDetails.barangay}',
                                            size: 16,
                                            color: AppColors.black,
                                            weight: FontWeight.w700,
                                            align: TextAlign.left,
                                            screenHeight: screenHeight,
                                            alignment: Alignment.centerLeft,
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