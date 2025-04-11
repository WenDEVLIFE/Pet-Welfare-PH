import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/SearchPetViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

import '../model/BarangayModel.dart';
import '../model/BreedModel.dart';
import '../model/CityModel.dart';
import '../model/ProvinceModel.dart';
import '../model/RegionModel.dart';
import '../utils/AppColors.dart';
import '../utils/ToastComponent.dart';
import '../view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../widgets/CustomButton.dart';
import '../widgets/CustomDropdown.dart';
import '../widgets/CustomTextField.dart';

class SearchPetModal extends StatelessWidget{
  const SearchPetModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchPetViewModel postViewModel = Provider.of<SearchPetViewModel>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        // This ensures the modal adjusts for the keyboard
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),

     child:Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
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
              Text(postViewModel.selectedSearchType == "Missing Pets" ? "Search Missing Pets" : postViewModel.selectedSearchType == "Found Pets" ? "Search Found Pet" : postViewModel.selectedSearchType == "Pet Adoption" ? "Search Pet Adoption" : "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
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
          Expanded(child:
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  CustomText(
                    text: 'Search Type',
                    size: 18,
                    color: Colors.black,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomDropDown(value: postViewModel.selectedSearchType,
                    items: postViewModel.SearchType,
                    onChanged: (String? newValue) {
                      postViewModel.setSearchType(newValue);
                    },
                    itemLabel: (String value) => value,
                    hint: 'Select Search Type',
                  ),
                  CustomText(
                    text: 'Pet Type',
                    size: 18,
                    color: Colors.black,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomDropDown<String>(
                    value: postViewModel.selectedPetType,
                    items: postViewModel.petTypes,
                    onChanged: (String? newValue) {
                      postViewModel.setPetType(newValue);
                    },
                    itemLabel: (String value) => value,
                    hint: 'Select Pet Type',
                  ),
                   if (postViewModel.selectedPetType == "Dog") ...[
                    CustomText(
                    text: 'Dog Breed',
                    size: 18,
                    color: Colors.black,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                  CustomDropDown<Breed>(
                    value: postViewModel.selectedDogBreed,
                    items: postViewModel.dogBreeds,
                    onChanged: (Breed? newValue) {
                      postViewModel.setDogBreed(newValue);
                    },
                    itemLabel: (Breed value) => value.name,
                    hint: 'Select Pet Breed',
                  ),
                  ],
                  if (postViewModel.selectedPetType == "Cat") ...[
                    CustomText(
                      text: 'Cat Breed',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown<Breed>(
                      value: postViewModel.selectedCatBreed,
                      items: postViewModel.catBreeds,
                      onChanged: (Breed? newValue) {
                        postViewModel.setCatBreed(newValue);
                      },
                      itemLabel: (Breed value) => value.name,
                      hint: 'Select Pet Breed',
                    ),
                  ],
                  if (postViewModel.selectedSearchType == "Missing Pets" || postViewModel.selectedSearchType == "Found Pets" ||  postViewModel.selectedSearchType =="Pet Adoption") ...[
                    CustomText(
                      text: 'Pet Color/ Pattern',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown<String>(
                      value: postViewModel.selectedColor,
                      items: postViewModel.colorpatter,
                      onChanged: (String? newValue) {
                        postViewModel.setColor(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Color/ Pattern',
                    ),
                    CustomText(
                      text: 'Pet Size',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown<String>(
                      value: postViewModel.selectedPetSize,
                      items: postViewModel.petSize,
                      onChanged: (String? newValue) {
                        postViewModel.setPetSize(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Size',
                    ),
                    CustomText(
                      text: 'Pet Gender',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown<String>(
                      value: postViewModel.selectedPetGender,
                      items: postViewModel.petGender,
                      onChanged: (String? newValue) {
                        postViewModel.setPetGender(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Gender',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Region, Province, and City',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'SmoochSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CustomDropDown<RegionModel>(
                            value: postViewModel.selectedRegion,
                            items: postViewModel.regions,
                            onChanged: (RegionModel? newValue) {
                              postViewModel.setSelectedRegion(newValue);
                            },
                            itemLabel: (RegionModel value) => value.region,
                            hint: 'Select Region',
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          SizedBox(height: screenHeight * 0.01),
                          if (postViewModel.selectedRegion != null)
                            SizedBox(height: screenHeight * 0.01),
                          CustomDropDown<ProvinceModel>(
                            value: postViewModel.selectedProvince,
                            items: postViewModel.provinces,
                            onChanged: (ProvinceModel? newValue) {
                              postViewModel.setSelectedProvince(newValue);
                            },
                            itemLabel: (ProvinceModel value) => value.provinceName,
                            hint: 'Select Province',
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          if (postViewModel.selectedProvince != null)
                            SizedBox(height: screenHeight * 0.01),
                          CustomDropDown<CityModel>(
                            value: postViewModel.selectedCity,
                            items: postViewModel.cities,
                            onChanged: (CityModel? newValue) {
                              postViewModel.setSelectedCity(newValue);
                            },
                            itemLabel: (CityModel value) => value.cityName,
                            hint: 'Select City',
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                    CustomText(
                      text: 'Address',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomTextField(controller:
                    postViewModel.addressController,
                        screenHeight: screenHeight,
                        hintText: 'Enter Address',
                        fontSize: 16,
                        keyboardType: TextInputType.text
                    ),
                  ],

                  Center(
                      child: CustomButton(
                        hint: 'Search',
                        size: 18,
                        color1: AppColors.orange,
                        textcolor2: Colors.white,
                        onPressed: () async {
                          postViewModel.search(context);
                          Navigator.of(context).pop();
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}