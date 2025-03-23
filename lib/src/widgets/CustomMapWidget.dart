// lib/widgets/CustomMapWidget.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/CreatePostViewModel.dart';
import 'package:provider/provider.dart';

import '../services/MapTilerKey.dart';

class CustomMapWidget extends StatelessWidget {
  final double height;
  final double lat;
  final double long;
  final LatLng? selectedLocation;
  final Function(LatLng) onLocationSelected;

  CustomMapWidget({
    required this.height,
    required this.lat,
    required this.long,
    this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final createPostViewModel = Provider.of<CreatePostViewModel>(context);

    return Container(
      height: height,
      child: MaplibreMap(
        styleString: "${MapTilerKey.styleUrl}?key=${MapTilerKey.apikey}",
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 15.0,
        ),
        onMapCreated: (MaplibreMapController controller) async {
          createPostViewModel.mapController = controller;
          await createPostViewModel.loadMarkerImage(controller); // Load custom marker
          if (selectedLocation != null) {
            createPostViewModel.addPin(selectedLocation!);
          }
        },
        onMapClick: (point, coordinates) async {
          if (createPostViewModel.mapController == null) return;

          // Update location
          onLocationSelected(coordinates);

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
    );
  }
}