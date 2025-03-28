import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/widgets/SelectRadiusWidget.dart';
import '../modal/locationModal.dart';
import '../services/MapTilerKey.dart';
import 'package:provider/provider.dart';

import '../utils/SessionManager.dart';
import '../widgets/MapSearchTextField.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Future<void> _mapFuture;
  late MapViewModel _mapViewModel;
  final sessionManager = SessionManager();
  String role = '';

  @override
  void initState() {
    super.initState();
    _mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    _mapFuture = multipliAsync();

    _mapViewModel.searchController.addListener(() {
      _mapViewModel.setSearchText();
    });
  }

  Future<void> multipliAsync() async {
    await Future.wait([
      _loadMap(),
      LoadRole(),
    ]);
  }

  Future<void> LoadRole() async {
    final user = await sessionManager.getUserInfo();
    setState(() {
      role = user?['role'] ?? ''; // Ensure role is not null
    });
  }

  Future<void> _loadMap() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void onMapCreated(MaplibreMapController controller) async {
    _mapViewModel.mapController = controller;
    _mapViewModel.initializeLoads();
    if (mounted) {
      _mapViewModel.initializeClickMarkers(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _mapViewModel.showDropdown = false;
            _mapViewModel.focusNode.unfocus();
          });
        },
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _mapFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading map'));
                } else {
                  return MaplibreMap(
                    styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_mapViewModel.lat, _mapViewModel.long),
                      zoom: 15.0,
                    ),
                    trackCameraPosition: true,
                    onMapCreated: onMapCreated,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MapSearchTextField(
                    controller: _mapViewModel.searchController,
                    focusNode: _mapViewModel.focusNode,
                    onSearch: _mapViewModel.searchLocation,
                    onClear: _mapViewModel.clearSearch,
                    hintText: 'Search your address...',
                  ),
                  if (_mapViewModel.showDropdown)
                    Consumer<MapViewModel>(
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
                                  setState(() {
                                    _mapViewModel.searchController.text = result['display_name'];
                                    _mapViewModel.showDropdown = false;
                                    _mapViewModel.focusNode.unfocus();
                                    locationModal().ShowLocationModal(context, result, _mapViewModel);
                                    _mapViewModel.initializeLoads();
                                  });
                                  _mapViewModel.addPin(LatLng(
                                    double.parse(result['lat']),
                                    double.parse(result['lon']),
                                  ));
                                  _mapViewModel.mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(
                                        double.parse(result['lat']),
                                        double.parse(result['lon']),
                                      ),
                                      15.0, // Specify the zoom level here
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
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        backgroundColor: AppColors.orange,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.sync, color: AppColors.white),
            backgroundColor: AppColors.orange,
            label: 'Refresh the map',
            onTap: () {
              _mapViewModel.refreshMarkers();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.near_me, color: AppColors.white),
            backgroundColor: AppColors.orange,
            label: 'Click for nearby rescuer, shelter, clinic',
            onTap: () {
              showDialog(context: context, builder: (context) => SelectRadiusWidget());
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.my_location, color: AppColors.white),
            backgroundColor: AppColors.orange,
            label: 'My Location',
            onTap: () {
              if (_mapViewModel.mapController != null) {
                _mapViewModel.mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(_mapViewModel.lat, _mapViewModel.long),
                      zoom: 15.0,
                    ),
                  ),
                );
              }
            },
          ),
          if(role.toLowerCase() != 'fur user') ...[
            SpeedDialChild(
              child: const Icon(Icons.house, color: AppColors.white),
              backgroundColor: AppColors.orange,
              label: 'My Pet Shelter & Clinic',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.shelterClinic);
              },
            ),
          ],
        ],
      ),
    );
  }
}