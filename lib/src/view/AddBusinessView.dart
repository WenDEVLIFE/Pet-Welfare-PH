import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/EstablishmentViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomButton.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../utils/ImageUtils.dart';
import '../services/MapTilerKey.dart';
import '../widgets/CustomDropdown.dart';
import '../widgets/CustomMapWidget.dart';
import '../widgets/MapSearchTextField.dart';

class AddShelterClinic extends StatefulWidget {
  const AddShelterClinic({Key? key}) : super(key: key);

  @override
  _AddShelterClinicState createState() => _AddShelterClinicState();
}

class _AddShelterClinicState extends State<AddShelterClinic> {
  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
    _initializeDataFuture = _initializeData(viewModel);
  }

  Future<void> _initializeData(EstablishmentViewModel viewModel) async {
    await viewModel.setInitialLocation();
    viewModel.clearTextFields();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Business Location',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: _initializeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<EstablishmentViewModel>(
              builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: screenHeight * 0.01),
                        CustomText(
                          text:'Business Name',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                            controller: viewModel.shelterNameController,
                            screenHeight: screenHeight,
                            hintText: 'Enter Business Name',
                            fontSize: 16,
                            keyboardType: TextInputType.text
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text:  'Business Profile',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundColor: AppColors.orange,
                                child: CircleAvatar(
                                  radius: 95,
                                  backgroundImage: viewModel.shelterImage.isNotEmpty
                                      ? FileImage(File(viewModel.shelterImage))
                                      : const AssetImage(ImageUtils.catPath) as ImageProvider,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.photo_camera, color: AppColors.white),
                                    onPressed: () => context.read<EstablishmentViewModel>().pickImage(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        const Text('Select Your Business Type',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'SmoochSans',
                                color: Colors.black)),
                        SizedBox(height: screenHeight * 0.01),
                        CustomDropDown<String>(
                          value: viewModel.selectEstablishment,
                          items: viewModel.establishmentType,
                          onChanged: (String? newValue) {
                            viewModel.updateEstablishmentType(newValue!);
                          },
                          itemLabel: (String value) => value,
                          hint: 'Business Type',
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text:   'Business Description',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                            controller: viewModel.shelterDescriptionController,
                            screenHeight: screenHeight,
                            hintText: 'Business Description',
                            fontSize: 16,
                            keyboardType: TextInputType.text
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text:'Business Address',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                            controller: viewModel.shelterAddressController,
                            screenHeight: screenHeight,
                            hintText: 'Enter Business Address',
                            fontSize: 16,
                            keyboardType: TextInputType.text
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text: 'Business Phone Number',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                            controller: viewModel.shelterPhoneNumber,
                            screenHeight: screenHeight,
                            hintText: 'Enter Business Phone Number',
                            fontSize: 16,
                            keyboardType: TextInputType.phone
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text: 'Business Email',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                            controller: viewModel.shelterEmailController,
                            screenHeight: screenHeight,
                            hintText: 'Enter Business Email',
                            fontSize: 16,
                            keyboardType: TextInputType.text
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomText(
                          text: 'Location',
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w700,
                          align: TextAlign.left,
                          screenHeight: screenHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Stack(
                          children: [
                            CustomMapWidget(
                              height: screenHeight * 0.4,
                              lat: viewModel.lat,
                              long: viewModel.long,
                              selectedLocation: viewModel.selectedLocation,
                              onLocationSelected: (LatLng coordinates) {
                                viewModel.updateLocation(coordinates);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  MapSearchTextField(
                                    controller: viewModel.searchController,
                                    focusNode: viewModel.focusNode,
                                    onSearch: viewModel.searchLocation,
                                    onClear: viewModel.clearSearch,
                                    hintText: 'Search your address...',
                                  ),
                                  if (viewModel.showDropdown)
                                    Consumer<EstablishmentViewModel>(
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
                                                  viewModel.searchController.text = result['display_name'];
                                                  viewModel.showDropdown = false;
                                                  viewModel.focusNode.unfocus();
                                                  viewModel.addPin(LatLng(
                                                    double.parse(result['lat']),
                                                    double.parse(result['lon']),
                                                  ));
                                                  viewModel.mapController?.animateCamera(
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
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child:  CustomButton(
                            hint: 'Add Business',
                            size:  14,
                            color1: AppColors.orange,
                            textcolor2: AppColors.white,
                            onPressed: () {
                              // Add your insert function to database
                              viewModel.insertActionEvent(context);
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}