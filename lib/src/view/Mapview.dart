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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
        trackCameraPosition: true,
      ),
    );
  }
}