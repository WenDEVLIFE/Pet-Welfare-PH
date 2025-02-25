import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../services/MapTilerKey.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Future<void> _mapFuture;
  late MapViewModel _mapViewModel;
  MaplibreMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    _mapViewModel.requestPermissions().then((_) {
      _mapViewModel.getLocation();
    });
    _mapViewModel.loadRole();
    _mapFuture = _loadMap();
  }

  Future<void> _loadMap() async {
    // Simulate a delay to mimic loading time
    await Future.delayed(Duration(seconds: 1));
  }

  void _onMapCreated(MaplibreMapController controller) {
    _mapController = controller;
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
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _mapFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading map'));
              } else {
                return MaplibreMap(
                  styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_mapViewModel.lat, _mapViewModel.long), // Example: San Francisco
                    zoom: 10.0,
                  ),
                  trackCameraPosition: true,
                  onMapCreated: _onMapCreated,
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.99,
              height: screenHeight * 0.08,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.transparent, width: 7),
              ),
              child: TextField(
                onChanged: (query) {
                  // Implement your search functionality here
                },
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.orange, width: 2), // Change the color here
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.orange, width: 2), // Change the color here
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
          ),
        ],
      ),
      floatingActionButton: _mapViewModel.role.toLowerCase() == 'pet rescuer' || _mapViewModel.role.toLowerCase() == 'pet shelter'
          ? SpeedDial(
        icon: Icons.menu,
        backgroundColor: AppColors.orange,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.my_location, color: AppColors.white),
            backgroundColor: AppColors.orange,
            label: 'My Location',
            onTap: () {
              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(_mapViewModel.lat, _mapViewModel.long),
                      zoom: 15.0, // Zoom level
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
              // Add your custom action here
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
              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(_mapViewModel.lat, _mapViewModel.long),
                      zoom: 15.0, // Zoom level
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