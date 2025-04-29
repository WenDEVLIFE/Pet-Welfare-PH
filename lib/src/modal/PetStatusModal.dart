import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';

import '../utils/AppColors.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomDropdown.dart';
import '../widgets/CustomText.dart';
import 'package:provider/provider.dart';

class PetStatusModal extends StatefulWidget{

  final String postId;
  final String category;

  PetStatusModal(this.postId, this.category);

   @override
  _PetStatusModalState createState() => _PetStatusModalState();

}

class _PetStatusModalState extends State<PetStatusModal> {
  late String postId;
  late String status;
  late String category;
  late PostViewModel postViewModel;

  @override
  void initState() {
    super.initState();
    postId = widget.postId;
    category = widget.category;
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.loadPetStatusOptions(category);
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                category =='Missing Pets' ? 'Update Missing Pet Status' :
                category == 'Found Pets' ? 'Update Found Pet Status' :
                category == 'Pet Adoption' ? 'Update Pet Adoption Status' :
                category =='Call for Aid' ? 'Update Call for Aid Status' :
                category =='Protect Our Pets: Report Abuse' ? 'Update Report Abuse Status' :
                'Update Pet Status' ,
                style: const TextStyle(
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
                    text: 'Select a Status',
                    size: 25,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomDropDown<String?>(
                    value: postViewModel.selectedPetStatus,
                    items: postViewModel.petStatusOptions,
                    onChanged: (String? newValue) {
                      postViewModel.setSelectedPetStatus(newValue);
                    },
                    itemLabel: (String? value) => value!,
                    hint: 'Select a Status Type',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: CustomButton(
                      hint: 'Update Status',
                      size: 16,
                      color1: AppColors.orange,
                      textcolor2: AppColors.white,
                      onPressed: () {
                        postViewModel.updatePetStatus(postId, context, category);
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