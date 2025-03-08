import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class VetAndTravelView extends StatefulWidget {
  const VetAndTravelView({Key? key}) : super(key: key);

  @override
  VetAndTravelState createState() => VetAndTravelState();
}

class VetAndTravelState extends State<VetAndTravelView> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build of VetAndTravelView
    return Scaffold(
        body: const Center(child: Text('Caring for Pets: Vet & Travel Insights')),floatingActionButton:  FloatingActionButton(
      backgroundColor: AppColors.orange,
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.white),
    ),
    );
  }

}