import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/ShelterClinicViewModel.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../utils/ImageUtils.dart';
import '../utils/MapTilerKey.dart';

class AddShelterClinic extends StatelessWidget {
  const AddShelterClinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Shelter & Clinic',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<ShelterClinicViewModel>(
        builder: (context, viewModel, child) {
          return FutureBuilder(
            future: viewModel.setInitialLocation(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.01),
                      const Text(
                        'Shelter/Clinic Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterNameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Name',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
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
                                  onPressed: () => context.read<ShelterClinicViewModel>().pickImage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text('SELECT YOUR ESTABLISHMENT TYPE',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          color: AppColors.gray,
                          border: Border.all(color: AppColors.gray, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.grey[800],
                          ),
                          child: DropdownButton<String>(
                            value: viewModel.selectEstablishment,
                            items: viewModel.establishmentType.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SmoochSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              viewModel.updateEstablishmentType(newValue!);
                            },
                            dropdownColor: AppColors.gray,
                            iconEnabledColor: Colors.grey,
                            style: const TextStyle(color: Colors.white),
                            selectedItemBuilder: (BuildContext context) {
                              return viewModel.establishmentType.map<Widget>((String item) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SmoochSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            isExpanded: true,
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterDescriptionController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Description',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterAddressController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Address',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Phone Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterPhoneNumber,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Phone Number',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterEmailController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Email',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Shelter/Clinic Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextField(
                        controller: viewModel.shelterPhoneNumber,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.gray,
                          border: OutlineInputBorder(),
                          hintText: 'Enter Shelter/Clinic Address',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SmoochSans',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: screenHeight * 0.4,
                        child:MaplibreMap(
                          styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(viewModel.lat, viewModel.long),
                            zoom: 15.0,
                          ),
                          onMapCreated: (MaplibreMapController controller) async {
                            viewModel.mapController = controller;
                            await viewModel.loadMarkerImage(controller); // Load custom marker
                          },

                          onMapClick: (point, coordinates) async {
                            if (viewModel.mapController == null) return;

                            // Update location
                            viewModel.updateLocation(coordinates);

                            // Remove previous markers
                            await viewModel.mapController!.clearSymbols();

                            // Add new marker
                            await viewModel.mapController!.addSymbol(SymbolOptions(
                              geometry: coordinates,
                              iconImage: "custom_marker", // Use loaded image
                              iconSize: 1.5,
                            ));

                            print("Pinned Location: ${coordinates.latitude}, ${coordinates.longitude}");
                            ToastComponent().showMessage(AppColors.orange,'Pinned Location:${coordinates.latitude}${coordinates.longitude}');
                          },
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                          },
                        ),

                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Container(
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your insert function to database
                              viewModel.insertActionEvent(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              'Add Shelter/Clinic',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}