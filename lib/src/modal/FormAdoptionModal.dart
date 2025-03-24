import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomButton.dart';
import 'package:provider/provider.dart';

import '../model/BarangayModel.dart';
import '../model/CityModel.dart';
import '../model/ProvinceModel.dart';
import '../model/RegionModel.dart';
import '../view_model/ApplyAdoptionViewModel.dart';
import '../widgets/CustomDropdown.dart';
import '../widgets/CustomTextField.dart';

class FormAdoptionModal extends StatelessWidget {
  final String postId;
  FormAdoptionModal(this.postId);

  @override
  Widget build(BuildContext context){
    ApplyAdoptionViewModel createPostViewModel = Provider.of<ApplyAdoptionViewModel>(context);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Adoption Form',
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: createPostViewModel.nameController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your full name',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomDropDown(
                    value: createPostViewModel.selectedAdoptionType,
                    items: createPostViewModel.adoptionType,
                    onChanged: (String? newValue) {
                      createPostViewModel.setSelectedAdoptionType(newValue!);
                    },
                    itemLabel: (String value) => value,
                    hint: 'Select Adoption Type',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: createPostViewModel.emailController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your email address',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Facebook Username',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: createPostViewModel.facebookUsernameController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your facebook username',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: createPostViewModel.phoneController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your phone number',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: createPostViewModel.addressController,
                    screenHeight: screenHeight,
                    hintText: 'Enter your full Address',
                    fontSize: 16,
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Region, Province, City and Barangay',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'SmoochSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomDropDown<RegionModel>(
                          value: createPostViewModel.selectedRegion,
                          items: createPostViewModel.regions,
                          onChanged: (RegionModel? newValue) {
                            createPostViewModel.setSelectedRegion(newValue);
                          },
                          itemLabel: (RegionModel value) => value.region,
                          hint: 'Select Region',
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        if (createPostViewModel.selectedRegion != null)
                          SizedBox(height: screenHeight * 0.01),
                        CustomDropDown<ProvinceModel>(
                          value: createPostViewModel.selectedProvince,
                          items: createPostViewModel.provinces,
                          onChanged: (ProvinceModel? newValue) {
                            createPostViewModel.setSelectedProvince(newValue);
                          },
                          itemLabel: (ProvinceModel value) => value.provinceName,
                          hint: 'Select Province',
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        if (createPostViewModel.selectedProvince != null)
                          SizedBox(height: screenHeight * 0.01),
                        CustomDropDown<CityModel>(
                          value: createPostViewModel.selectedCity,
                          items: createPostViewModel.cities,
                          onChanged: (CityModel? newValue) {
                            createPostViewModel.setSelectedCity(newValue);
                          },
                          itemLabel: (CityModel value) => value.cityName,
                          hint: 'Select City',
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        if (createPostViewModel.selectedCity != null)
                          SizedBox(height: screenHeight * 0.01),
                        CustomDropDown<BarangayModel>(
                          value: createPostViewModel.selectedBarangay,
                          items: createPostViewModel.barangays,
                          onChanged: (BarangayModel? newValue) {
                            createPostViewModel.setSelectedBarangay(newValue);
                          },
                          itemLabel: (BarangayModel value) => value.barangayName,
                          hint: 'Select Barangay',
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: CustomButton(
                      hint: 'Submit',
                      size: 16,
                      color1: AppColors.orange,
                      textcolor2: AppColors.white,
                      onPressed: () {
                        createPostViewModel.submitAdoptionForm(postId);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}