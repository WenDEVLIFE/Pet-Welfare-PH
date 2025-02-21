import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import '../utils/MapTilerKey.dart';
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

  @override
  void initState() {
    super.initState();
    _mapFuture = _loadMap();
    _mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    Provider.of<MapViewModel>(context, listen: false).requestPermissions();
    Provider.of<MapViewModel>(context, listen: false).getLocation();
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
    return Scaffold(
      body: FutureBuilder<void>(
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
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.my_location, color: AppColors.white,),
      ),
    );
  }
}