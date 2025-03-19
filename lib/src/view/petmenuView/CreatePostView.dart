import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
import '../../widgets/CustomTextField.dart';

class CreatePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CreatePostViewModel createPostViewModel = Provider.of<CreatePostViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: createPostViewModel.selectedChip == "Missing Pets"
              ? 'Post a missing pets'
              : createPostViewModel.selectedChip == "Found Pets"
              ? 'Post a found pets'
              : createPostViewModel.selectedChip == "Pet Adoption"
              ? 'Post for adoption'
              : 'Create a post',
          size: 18,
          color: Colors.black,
          weight: FontWeight.w700,
          align: TextAlign.left,
          screenHeight: screenHeight,
          alignment: Alignment.centerLeft,
        ),
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
                  : 'Create a post',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.2,
                child: Column(
                  children: [
                    CustomText(
                      text:  'Upload a picture',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => createPostViewModel.pickImage(),
                            child: Container(
                              width: screenWidth * 0.2,
                              height: screenHeight * 0.1,
                              color: Colors.grey[200],
                              child: const Icon(Icons.add_a_photo, color: Colors.grey),
                            ),
                          ),
                          ...createPostViewModel.images.map((image) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  width: 100,
                                  height: 100,
                                  child: Image.file(image, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      createPostViewModel.removeImage(image);
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(Icons.close, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
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
            if (createPostViewModel.selectedChip == "Missing Pets" || createPostViewModel.selectedChip == "Found Pets") ...[
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
              if(createPostViewModel.selectedPetType =='Cat' || createPostViewModel.selectedPetType =='Dog') ...[
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
                  createPostViewModel.setPetGender(newValue);
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
                  createPostViewModel.setPetGender(newValue);
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
                  value: createPostViewModel.selectPedBreed,
                  items: createPostViewModel.catBreeds,
                  onChanged: (Breed? newValue) {
                    createPostViewModel.selectedBreed(newValue);
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
                  value: createPostViewModel.selectPedBreed,
                  items: createPostViewModel.dogBreeds,
                  onChanged: (Breed? newValue) {
                    createPostViewModel.selectedBreed(newValue);
                  },
                  itemLabel: (Breed value) => value.name,
                  hint: 'Select Dog Breed',
                ),
              ],
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
                    Container(
                      height: screenHeight * 0.4,
                      child: MaplibreMap(
                        styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(createPostViewModel.lat, createPostViewModel.long),
                          zoom: 15.0,
                        ),
                        onMapCreated: (MaplibreMapController controller) async {
                          createPostViewModel.mapController = controller;
                          await createPostViewModel.loadMarkerImage(controller); // Load custom marker
                          if (createPostViewModel.selectedLocation != null) {
                            createPostViewModel.addPin(createPostViewModel.selectedLocation!);
                          }
                        },
                        onMapClick: (point, coordinates) async {
                          if (createPostViewModel.mapController == null) return;

                          // Update location
                          createPostViewModel.updateLocation(coordinates);

                          // Remove previous markers
                          await createPostViewModel.mapController!.clearSymbols();

                          // Add new marker
                          await createPostViewModel.mapController!.addSymbol(SymbolOptions(
                            geometry: coordinates,
                            iconImage: "custom_marker", // Use loaded image
                            iconSize: 1.5,
                          ));

                          print("Pinned Location: ${coordinates.latitude}, ${coordinates.longitude}");
                          ToastComponent().showMessage(AppColors.orange, 'Pinned Location: ${coordinates.latitude}, ${coordinates.longitude}');
                        },
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        },
                      ),
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
              CustomText(
                  text: createPostViewModel.selectedChip == "Missing Pets"
                  ? 'Enter the Street Address, Building, House No for found pet'
                  : createPostViewModel.selectedChip == "Found Pets"
                  ? 'Enter the Street Address, Building, House No for found pet'
                  : 'Enter the Street Address, Building, House No for found pet',
                  size: 18,
                  color: Colors.black,
                  weight: FontWeight.w700,
                  align: TextAlign.left,
                  screenHeight: screenHeight,
                alignment: Alignment.centerLeft,
              ),
              CustomTextField(
                controller: createPostViewModel.address,
                screenHeight: screenHeight,
                hintText: 'Enter Street Address, Building, House No...',
                fontSize: 16,
                keyboardType: TextInputType.text,
              ),
            ],
               if (createPostViewModel.selectedChip == "Pet Adoption") ...[

                 ],
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  createPostViewModel.PostNow(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text(
                  'Post Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}