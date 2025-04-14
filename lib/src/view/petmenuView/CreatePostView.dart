import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomButton.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomDropdown.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:pet_welfrare_ph/src/widgets/MapSearchTextField.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../model/BarangayModel.dart';
import '../../model/BreedModel.dart';
import '../../model/CityModel.dart';
import '../../model/ProvinceModel.dart';
import '../../model/RegionModel.dart';
import '../../services/MapTilerKey.dart';
import '../../utils/AppColors.dart';
import '../../utils/ToastComponent.dart';
import '../../view_model/CreatePostViewModel.dart';
import '../../widgets/CustomMapWidget.dart';
import '../../widgets/CustomTextField.dart';
import '../../widgets/ImageUploadWidget.dart';
import '../../widgets/TagWidget.dart';

class CreatePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CreatePostViewModel createPostViewModel = Provider.of<CreatePostViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomText(
              text: createPostViewModel.selectedChip == "Missing Pets"
                  ? 'Post a missing pet'
                  : createPostViewModel.selectedChip == "Found Pets"
                  ? 'Post a found pet'
                  : createPostViewModel.selectedChip == "Pet Adoption"
                  ? 'Post for adoption'
                  : createPostViewModel.selectedChip == "Pet Insights"
                  ? 'Post for insights'
                  : 'Create a post',
              size: 18,
              color: Colors.white,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
               createPostViewModel.notifyNotice(context);
            },
          ),
        ],
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomText(
              text:  createPostViewModel.selectedChip == "Missing Pets"
                  ? 'Enter the details of the missing pet'
                  : createPostViewModel.selectedChip == "Found Pets"
                  ? 'Enter the details of the found pet'
                  : createPostViewModel.selectedChip == "Pet Adoption"
                  ? 'Enter the details of the pet for adoption'
                  : createPostViewModel.selectedChip == "Find a Home: Rescue & Shelter"
                  ? 'Enter the details of the Rescue & Shelter'
                  : createPostViewModel.selectedChip == "Pet Adoption"
                  ? 'Enter the details of the pet for adoption'
                  : 'Create a post' ,
              size: 18,
              color: Colors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.3,
                child: TextField(
                  controller: createPostViewModel.postController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your post here...',
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
            ),
            ImageUploadWidget(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              images: createPostViewModel.images,
              onPickImage: createPostViewModel.pickImage,
              onRemoveImage: createPostViewModel.removeImage,
            ),
            CustomText(
              text: 'Tags',
              size: 18,
              color: Colors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TagsInputWidget(
                tagController: createPostViewModel.tagController,
                tags: createPostViewModel.tags,
                onAddTag: createPostViewModel.addTag,
                onRemoveTag: createPostViewModel.removeTag,
                screenHeight: screenHeight,
              ),
            ),
            CustomText(
              text: 'Select a category',
              size: 18,
              color: Colors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            CustomDropDown(value: createPostViewModel.selectedChip,
                items: createPostViewModel.chipLabels1,
                onChanged: (String? newValue) {
                  createPostViewModel.setSelectRole(newValue!);
                },
                itemLabel: (String value) => value,
                hint: 'Select a category',
            ),
            if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets" ||  createPostViewModel.selectedChip =="Pet Adoption") ...[
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
                  controller: createPostViewModel.petName,
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
              CustomDropDown(value: createPostViewModel.selectedPetType,
                items: createPostViewModel.petTypes,
                onChanged: (String? newValue) {
                  createPostViewModel.setPetType(newValue);
                },
                itemLabel: (String value) => value,
                hint: 'Select Pet Type',
              ),
              if(createPostViewModel.selectedPetType =='Cat' || createPostViewModel.selectedPetType =='Dog') ...[
                 if(createPostViewModel.selectedPetType =='Missing Pets' || createPostViewModel.selectedPetType =='Found Pets') ...[
                   CustomText(
                     text: 'Pet Collar',
                     size: 18,
                     color: Colors.black,
                     weight: FontWeight.w700,
                     align: TextAlign.left,
                     screenHeight: screenHeight,
                     alignment: Alignment.centerLeft,
                   ),
                   CustomDropDown(value: createPostViewModel.selectedCollar,
                     items: createPostViewModel.collarList,
                     onChanged: (String? newValue) {
                       createPostViewModel.setCollarType(newValue);
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
              CustomDropDown(value: createPostViewModel.selectedPetAge,
                items: createPostViewModel.petAgeList,
                onChanged: (String? newValue) {
                  createPostViewModel.setPetAge(newValue);
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
              CustomDropDown(value: createPostViewModel.selectedPetGender,
                items: createPostViewModel.petGender,
                onChanged: (String? newValue) {
                  createPostViewModel.setPetGender(newValue);
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
              CustomDropDown(value: createPostViewModel.selectedPetSize,
                items: createPostViewModel.petSize,
                onChanged: (String? newValue) {
                  createPostViewModel.setPetSize(newValue);
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
              CustomDropDown(value: createPostViewModel.selectedColorPattern,
                items: createPostViewModel.colorpatter,
                onChanged: (String? newValue) {
                  createPostViewModel.setColor(newValue);
                },
                itemLabel: (String value) => value,
                hint: 'Select Colors or patterns',
              ),
              if (createPostViewModel.selectedPetType == 'Cat') ...[
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
                  value: createPostViewModel.selectedCatBreed,
                  items: createPostViewModel.catBreeds,
                  onChanged: (Breed? newValue) {
                    createPostViewModel.selectedCatBreed1(newValue);
                  },
                  itemLabel: (Breed value) => value.name,
                  hint: 'Select Cat Breed',
                ),
              ],
              if (createPostViewModel.selectedPetType == 'Dog') ...[
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
                  value: createPostViewModel.selectedDogBreed,
                  items: createPostViewModel.dogBreeds,
                  onChanged: (Breed? newValue) {
                    createPostViewModel.selectedDogBreed2(newValue);
                  },
                  itemLabel: (Breed value) => value.name,
                  hint: 'Select Dog Breed',
                ),
              ],
               if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
                 CustomText(
                   text:   createPostViewModel.selectedChip == "Missing Pets"
                       ? 'Select the date the pet went missing'
                       : createPostViewModel.selectedChip == "Found Pets"
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
                     controller: createPostViewModel.dateController,
                     readOnly: true,
                     onTap: () async {
                       final DateTime? date = await showDatePicker(
                         context: context,
                         initialDate: DateTime.now(),
                         firstDate: DateTime(2000),
                         lastDate: DateTime(2100),
                       );
                       if (date != null) {
                         createPostViewModel.dateController.text = date.toLocal().toString().split(' ')[0];
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
                      value: createPostViewModel.selectedRegion,
                      items: createPostViewModel.regions,
                      onChanged: (RegionModel? newValue) {
                        createPostViewModel.setSelectedRegion(newValue);
                      },
                      itemLabel: (RegionModel value) => value.region,
                      hint: 'Select Region',
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
              if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
                CustomText(
                  text: createPostViewModel.selectedChip == "Missing Pets"
                      ? 'Select a location for missing pet'
                      : createPostViewModel.selectedChip == "Found Pets"
                      ? 'Select a location for found pet'
                      : 'Select a location for found pet',
                  size: 18,
                  color: Colors.black,
                  weight: FontWeight.w700,
                  align: TextAlign.left,
                  screenHeight: screenHeight,
                  alignment: Alignment.centerLeft,
                ),
                Stack(
                  children: [
                    CustomMapWidget(
                      height: screenHeight * 0.4,
                      lat: createPostViewModel.lat,
                      long: createPostViewModel.long,
                      selectedLocation: createPostViewModel.selectedLocation,
                      onLocationSelected: (LatLng coordinates) {
                        createPostViewModel.updateLocation(coordinates);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                        MapSearchTextField(
                            controller: createPostViewModel.searchController,
                            focusNode: createPostViewModel.focusNode,
                            onSearch: createPostViewModel.searchLocation,
                            onClear: createPostViewModel.clearSearch,
                            hintText: 'Search your address...',

                        ),
                          if (createPostViewModel.showDropdown)
                            Consumer<CreatePostViewModel>(
                              builder: (context, viewModel, child) {
                                return Container(
                                  height: screenHeight * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Set the background color
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView.builder(
                                    itemCount: viewModel.searchResults.length,
                                    itemBuilder: (context, index) {
                                      final result = viewModel.searchResults[index];
                                      return ListTile(
                                        title: Text(result['display_name']),
                                        onTap: () {
                                          createPostViewModel.searchController.text = result['display_name'];
                                          createPostViewModel.showDropdown = false;
                                          createPostViewModel.focusNode.unfocus();
                                          createPostViewModel.addPin(LatLng(
                                            double.parse(result['lat']),
                                            double.parse(result['lon']),
                                          ));
                                          createPostViewModel.mapController?.animateCamera(
                                            CameraUpdate.newLatLng(
                                              LatLng(
                                                double.parse(result['lat']),
                                                double.parse(result['lon']),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
            if(createPostViewModel.selectedChip=='Caring for Pets: Vet & Travel Insights')...[
              CustomText(
                text: 'Clinic Name/Establishment Name',
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
                  controller: createPostViewModel.clinicNameController,
                  screenHeight: screenHeight,
                  hintText: 'Enter clinic or establishment name...',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
                ),
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
            ],
               if (createPostViewModel.selectedChip == "Pet Adoption" || createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
                 CustomText(
                   text: createPostViewModel.selectedChip == "Missing Pets"
                       ? 'Enter the Street Address, Building, House No for missing pet'
                       : createPostViewModel.selectedChip == "Found Pets"
                       ? 'Enter the Street Address, Building, House No for found pet'
                       : createPostViewModel.selectedChip == "Pet Adoption"
                       ? 'Enter the Street Address, Building, House No for pet adoption'
                       : createPostViewModel.selectedChip == "Pet Care Insights"
                       ? 'Enter the Street Address, Building, House No for pet insights'
                       : 'Enter the Street Address, Building, House No',

                   size: 18,
                   color: Colors.black,
                   weight: FontWeight.w700,
                   align: TextAlign.left,
                   screenHeight: screenHeight,
                   alignment: Alignment.centerLeft,
                 ),
                 Padding(padding: const EdgeInsets.all(10.0),
                   child:CustomTextField(
                     controller: createPostViewModel.address,
                     screenHeight: screenHeight,
                     hintText: 'Enter Street Address, Building, House No...',
                     fontSize: 16,
                     keyboardType: TextInputType.text,
                   ),
                 ),
                 ],
            if(createPostViewModel.selectedChip == 'Call for Aid')...[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type of Donation',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CustomDropDown<String?>(
                value: createPostViewModel.selectedTypeOfDonation,
                items: createPostViewModel.typeOfDonation,
                onChanged: (String? newValue) {
                  createPostViewModel.setselectedDonation(newValue);
                },
                itemLabel: (String? value) => value!,
                hint: 'Select a Donation Type',
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bank',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CustomDropDown<String?>(
                value: createPostViewModel.selectedBankType,
                items: createPostViewModel.bankType,
                onChanged: (String? newValue) {
                  createPostViewModel.setSelectedBank(newValue);
                },
                itemLabel: (String? value) => value!,
                hint: 'Select Bank',
              ),
              CustomText(
                text: 'Bank Holder Name',
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
                  controller: createPostViewModel.bankNameController,
                  screenHeight: screenHeight,
                  hintText: 'Enter bank holder name...',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
                ),
              ),
              CustomText(
                text: 'Account Number',
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
                  controller: createPostViewModel.accountNameController,
                  screenHeight: screenHeight,
                  hintText: 'Enter bank account number...',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Purpose of Raising Funds',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              CustomDropDown<String?>(
                value: createPostViewModel.selectedDonationType,
                items: createPostViewModel.donationType,
                onChanged: (String? newValue) {
                  createPostViewModel.setSelectDonation(newValue);
                },
                itemLabel: (String? value) => value!,
                hint: 'Select a purpose of raising funds',
              ),
              CustomText(
                text: 'Estimated Amount',
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
                  controller: createPostViewModel.amountController,
                  screenHeight: screenHeight,
                  hintText: 'Enter estimated amount...',
                  fontSize: 16,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
            Center(
              child: CustomButton(
                  hint: 'Post Now',
                  size: 18,
                  color1: AppColors.orange,
                  textcolor2: Colors.white,
                onPressed: () async {
                createPostViewModel.PostNow(context);
                },
              )
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}