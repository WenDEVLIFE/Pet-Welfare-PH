import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../utils/MapTilerKey.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Future<void> _mapFuture;

  @override
  void initState() {
    super.initState();
    _mapFuture = _loadMap();
  }

  Future<void> _loadMap() async {
    // Simulate a delay to mimic loading time
    await Future.delayed(Duration(seconds: 1));
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.7749, -122.4194), // Example: San Francisco
                zoom: 10.0,
              ),
              trackCameraPosition: true,
            );
          }
        },
      ),
    );
  }
}