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
import '../modal/locationModal.dart';
import '../services/MapTilerKey.dart';
import 'package:provider/provider.dart';

import '../utils/SessionManager.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Future<void> _mapFuture;
  late MapViewModel _mapViewModel;
  final sessionManager = SessionManager();
  String role ='';
  bool _showDropdown = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    _mapFuture = multipliAsync();

    _searchController.addListener(() {
      setState(() {
        _showDropdown = _searchController.text.isNotEmpty;
      });
    });
  }

  Future<void> multipliAsync() async {
    await Future.wait([
      _loadMap(),
      LoadRole(),
      _mapViewModel.requestPermissions(),
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
    await _mapViewModel.initializeLoads();
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
            _showDropdown = false;
            _focusNode.unfocus();
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
                      zoom: 10.0,
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
                  Container(
                    width: screenWidth * 0.99,
                    height: screenHeight * 0.08,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.transparent, width: 7),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (query) {
                        _mapViewModel.searchLocation(query);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.search, color: Colors.black),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            _searchController.clear();
                            _mapViewModel.removePins();
                          },
                        )
                            : null,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.orange, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.orange, width: 2),
                        ),
                        hintText: 'Search an address....',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                      ),
                      style: const TextStyle(
                        fontFamily: 'LeagueSpartan',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_showDropdown)
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
                                    _searchController.text = result['display_name'];
                                    _showDropdown = false;
                                    _focusNode.unfocus();
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
      floatingActionButton: role.toLowerCase() == 'pet rescuer' || role.toLowerCase() == 'pet shelter'
          ? SpeedDial(
        icon: Icons.menu,
        backgroundColor: AppColors.orange,
        children: [
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
          SpeedDialChild(
            child: const Icon(Icons.house, color: AppColors.white),
            backgroundColor: AppColors.orange,
            label: 'My Pet Shelter & Clinic',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.shelterClinic);
            },
          ),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.orange,
            onPressed: () {
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
            child: const Icon(Icons.my_location, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}