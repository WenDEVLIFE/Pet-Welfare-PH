import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/DialogView/ChangeEstablishmentProfile.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:provider/provider.dart';

import '../services/MapTilerKey.dart';
import '../utils/ImageUtils.dart';
import '../utils/ToastComponent.dart';
import '../view_model/EstablishmentViewModel.dart';

class ViewEstablishmentView extends StatefulWidget {
  const ViewEstablishmentView({Key? key}) : super(key: key);

  @override
  ViewEstablishmentScreenState createState() => ViewEstablishmentScreenState();
}

class ViewEstablishmentScreenState extends State<ViewEstablishmentView> {

  late String id;
  late String establismentStat;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? data =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (data != null) {
        viewModel.shelterNameController.text = data['establishmentName'] ?? '';
        viewModel.shelterDescriptionController.text = data['establishmentDescription'] ?? '';
        viewModel.shelterAddressController.text = data['establishmentAddress'] ?? '';
        viewModel.shelterPhoneNumber.text = data['establishmentPhoneNumber'] ?? '';
        viewModel.shelterEmailController.text = data['establishmentEmail'] ?? '';
        viewModel.selectedLocation = LatLng(data['establishmentLat'], data['establishmentLong']);
        establismentStat = data['establishmentStatus'];
        ToastComponent().showMessage(AppColors.orange, 'Pinned Location: ${data['establishmentLat']}, ${data['establishmentLong']}');
        id = data['establishmentId'];

        if (data['establishmentPicture']?.startsWith('http')) {
          viewModel.setImageUrl(data['establishmentPicture']);
        } else {
          viewModel.shelterImage = data['establishmentPicture'] ?? '';
        }

        viewModel.selectEstablishment = data['establishmentType'];

        print(data['establishmentType']);

        if (data['establishmentLat'] != null && data['establishmentLong'] != null) {
          try {
            double lat = double.parse(data['establishmentLat'].toString());
            double long = double.parse(data['establishmentLong'].toString());
            print('Setting initial location to: $lat, $long');
            // Update the location in the view model
            viewModel.selectedLocation = LatLng(lat, long);
            // If map controller exists, update the pin
            if (viewModel.mapController != null) {
              print('Map controller is available, adding pin...');
              viewModel.addPin(LatLng(viewModel.selectedLocation!.latitude, viewModel.selectedLocation!.longitude));
            } else {
              print('Map controller is not available yet.');
            }
          } catch (e) {
            print('Error parsing location coordinates: $e');
            ToastComponent().showMessage(Colors.red, 'Error setting location');
          }
        }
      }
      // Call setInitialLocation here, after the first frame is built
      viewModel.setInitialLocation();
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Establishment Details',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Consumer<EstablishmentViewModel>(
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
                      Text(
                        viewModel.shelterNameController.text,
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
                            buildProfileImage(viewModel),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text('ESTABLISHMENT TYPE',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        viewModel.selectEstablishment,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
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
                      Text(
                        viewModel.shelterDescriptionController.text,
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
                      Text(
                        viewModel.shelterAddressController.text,
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
                      Text(
                        viewModel.shelterPhoneNumber.text,
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
                      Text(
                        viewModel.shelterEmailController.text,
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
                        child:MapLibreMap(
                            styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                            myLocationEnabled: true,
                            onMapCreated: (MapLibreMapController controller) async {
                              final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
                              viewModel.mapController = controller;
                              await viewModel.loadMarkerImage(controller); // Load custom marker
                              if (viewModel.selectedLocation != null) {

                                // get the selected location
                                viewModel.addPin(LatLng(viewModel.selectedLocation!.latitude, viewModel.selectedLocation!.longitude));
                              }
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(viewModel.selectedLocation!.latitude, viewModel.selectedLocation!.longitude),
                              zoom: 15.0,
                            ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (establismentStat =='Pending') ...[
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
                              Map<String, dynamic> data = {
                                'establishmentId': id,
                                'establishmentName': viewModel.shelterNameController.text,
                                'establishmentDescription': viewModel.shelterDescriptionController.text,
                                'establishmentAddress': viewModel.shelterAddressController.text,
                                'establishmentPhoneNumber': viewModel.shelterPhoneNumber.text,
                                'establishmentEmail': viewModel.shelterEmailController.text,
                                'establishmentPicture': viewModel.shelterImage,
                                'EstablishmentType': viewModel.selectEstablishment,
                                'lat': viewModel.selectedLocation!.latitude,
                                'long': viewModel.selectedLocation!.longitude,
                                'EstablishmentStatus': 'Approved',
                              };
                              viewModel.verifier(data, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            ),
                            child: const Text(
                              'Approve Establishment',
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
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final viewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
                      Map<String, dynamic> data = {
                        'establishmentId': id,
                        'establishmentName': viewModel.shelterNameController.text,
                        'establishmentDescription': viewModel.shelterDescriptionController.text,
                        'establishmentAddress': viewModel.shelterAddressController.text,
                        'establishmentPhoneNumber': viewModel.shelterPhoneNumber.text,
                        'establishmentEmail': viewModel.shelterEmailController.text,
                        'establishmentPicture': viewModel.shelterImage,
                        'EstablishmentType': viewModel.selectEstablishment,
                        'lat': viewModel.selectedLocation!.latitude,
                        'long': viewModel.selectedLocation!.longitude,
                        'EstablishmentStatus': 'Denied',
                      };
                      viewModel.verifier(data, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    ),
                    child: const Text(
                      'Denied Establishment',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                      ],
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

  Widget buildProfileImage(EstablishmentViewModel viewModel) {
    ImageProvider? imageProvider;

    try {
      if (viewModel.isNetworkImage && viewModel.shelterImage.isNotEmpty) {
        // Load from network
        imageProvider = CachedNetworkImageProvider(viewModel.shelterImage);
      } else if (viewModel.shelterImage.isNotEmpty && File(viewModel.shelterImage).existsSync()) {
        // Load from file (ensure the file exists)
        imageProvider = FileImage(File(viewModel.shelterImage));
      } else {
        // Load default asset image
        imageProvider = const AssetImage(ImageUtils.catPath);
      }
    } catch (e) {
      print('Error loading image: $e');
      imageProvider = const AssetImage(ImageUtils.catPath);
    }

    return CircleAvatar(
      radius: 100,
      backgroundColor: AppColors.orange,
      child: CircleAvatar(
        radius: 95,
        backgroundImage: imageProvider,
        onBackgroundImageError: (exception, stackTrace) {
          print('Image load error: $exception');
          ToastComponent().showMessage(Colors.red, 'Error loading image');
        },
      ),
    );
  }
}