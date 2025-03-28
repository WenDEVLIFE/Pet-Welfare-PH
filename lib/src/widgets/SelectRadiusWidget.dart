import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../utils/AppColors.dart';

class SelectRadiusWidget extends StatefulWidget {
  @override
  _SelectRadiusWidgetState createState() => _SelectRadiusWidgetState();
}

class _SelectRadiusWidgetState extends State<SelectRadiusWidget> {
  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = Provider.of<MapViewModel>(context);

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Location Type',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              RadioListTile<String>(
                title: const Text('Search All Locations (rescuer, establishment, missing and found pets)'),
                value: 'Search All Locations',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectLocationType,
                onChanged: (value) {
                  mapViewModel.setSelectLocation(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Rescuer Only'),
                value: 'Rescuer Only',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectLocationType,
                onChanged: (value) {
                  mapViewModel.setSelectLocation(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Establishment Only'),
                value: 'Establishment Only',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectLocationType,
                onChanged: (value) {
                  mapViewModel.setSelectLocation(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Missing Pets Only'),
                value: 'Missing Pets Only',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectedRadius,
                onChanged: (value) {
                  mapViewModel.setSelectLocation(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Found Pets Only'),
                value: 'Found Pets Only',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectedRadius,
                onChanged: (value) {
                  mapViewModel.setSelectLocation(value);
                },
              ),
              const Text(
                'Select Radius',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the radius you want to search for',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text('1km to 5km'),
                value: '1km to 5km',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectedRadius,
                onChanged: (value) {
                  mapViewModel.setSelectedRadius(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('5km to 10km'),
                value: '5km to 10km',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectedRadius,
                onChanged: (value) {
                  setState(() {
                    mapViewModel.setSelectedRadius(value);
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('10km to 20km'),
                value: '10km to 20km',
                activeColor: AppColors.orange,
                groupValue: mapViewModel.selectedRadius,
                onChanged: (value) {
                  mapViewModel.setSelectedRadius(value);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      ProgressDialog pd = ProgressDialog(context: context);
                      pd.show(max: 100, msg: 'Searching nearest locations');
                      mapViewModel.initializeNearby(context);
                      Future.delayed(const Duration(seconds: 2), () {
                        pd.close();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}