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

import '../widgets/CustomDropdown.dart';
import '../widgets/CustomTextField.dart';

class SearchPetModal extends StatelessWidget{
  const SearchPetModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchPetViewModel postViewModel = Provider.of<SearchPetViewModel>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
              const Text( 'Search for PetDetails',
                style: TextStyle(
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
                    hint: 'Select Pet Type',
                  ),
                  if (postViewModel.selectedSearchType == "Missing Pets" || postViewModel.selectedSearchType == "Found Pets" ||  postViewModel.selectedSearchType =="Pet Adoption") ...[
                    CustomText(
                      text: 'Pet Name',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomTextField(
                        controller: postViewModel.petnameController,
                        screenHeight: screenHeight,
                        hintText: 'Enter pet name...',
                        fontSize: 16,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    CustomText(
                      text: 'Select Pet Type',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown(value: postViewModel.selectedPetType,
                      items: postViewModel.petTypes,
                      onChanged: (String? newValue) {
                        postViewModel.setPetType(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Type',
                    ),
                    if(postViewModel.selectedPetType =='Cat' || postViewModel.selectedPetType =='Dog') ...[
                      if(postViewModel.selectedPetType =='Missing Pets' || postViewModel.selectedPetType =='Found Pets') ...[
                        CustomText(
                          text: 'Pet Collar',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        CustomDropDown(value: postViewModel.selectedCollar,
                          items: postViewModel.collarList,
                          onChanged: (String? newValue) {
                            postViewModel.setCollarType(newValue);
                          },
                          itemLabel: (String value) => value,
                          hint: 'Select Pet Collar',
                        ),
                      ],
                    ],
                    CustomText(
                      text: 'Pet Age',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown(value: postViewModel.selectedPetAge,
                      items: postViewModel.petAgeList,
                      onChanged: (String? newValue) {
                        postViewModel.setPetAge(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Age',
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
                    CustomDropDown(value: postViewModel.selectedPetGender,
                      items: postViewModel.petGender,
                      onChanged: (String? newValue) {
                        postViewModel.setPetGender(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Gender',
                    ),
                    CustomText(
                      text:  'Pet Size',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown(value: postViewModel.selectedPetSize,
                      items: postViewModel.petSize,
                      onChanged: (String? newValue) {
                        postViewModel.setPetSize(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Pet Size',
                    ),
                    CustomText(
                      text:   'Colors or patterns',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomDropDown(value: postViewModel.selectedColor,
                      items: postViewModel.colorpatter,
                      onChanged: (String? newValue) {
                        postViewModel.setColor(newValue);
                      },
                      itemLabel: (String value) => value,
                      hint: 'Select Colors or patterns',
                    ),
                    if (postViewModel.selectedPetType == 'Cat') ...[
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cat Breed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'SmoochSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      CustomDropDown<Breed>(
                        value: postViewModel.selectedCatBreed,
                        items: postViewModel.catBreeds,
                        onChanged: (Breed? newValue) {
                          postViewModel.selectedCatBreed1(newValue);
                        },
                        itemLabel: (Breed value) => value.name,
                        hint: 'Select Cat Breed',
                      ),
                    ],
                    if (postViewModel.selectedPetType == 'Dog') ...[
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Dog Breed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'SmoochSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      CustomDropDown<Breed>(
                        value: postViewModel.selectedDogBreed,
                        items: postViewModel.dogBreeds,
                        onChanged: (Breed? newValue) {
                          postViewModel.selectedDogBreed2(newValue);
                        },
                        itemLabel: (Breed value) => value.name,
                        hint: 'Select Dog Breed',
                      ),
                    ],
                    if (postViewModel.selectedSearchType == "Missing Pets" || postViewModel.selectedSearchType == "Found Pets") ...[
                      CustomText(
                        text:   postViewModel.selectedSearchType == "Missing Pets"
                            ? 'Select the date the pet went missing'
                            : postViewModel.selectedSearchType == "Found Pets"
                            ? 'Select the date the pet was found'
                            : 'Select the date the pet was found',
                        size: 18,
                        color: Colors.black,
                        weight: FontWeight.w700,
                        align: TextAlign.left,
                        screenHeight: screenHeight,
                        alignment: Alignment.centerLeft,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: postViewModel.dateController,
                          readOnly: true,
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              postViewModel.dateController.text = date.toLocal().toString().split(' ')[0];
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Select a date...',
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
                    ],
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
                          if (postViewModel.selectedCity != null)
                            SizedBox(height: screenHeight * 0.01),
                          CustomDropDown<BarangayModel>(
                            value: postViewModel.selectedBarangay,
                            items: postViewModel.barangays,
                            onChanged: (BarangayModel? newValue) {
                              postViewModel.setSelectedBarangay(newValue);
                            },
                            itemLabel: (BarangayModel value) => value.barangayName,
                            hint: 'Select Barangay',
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}