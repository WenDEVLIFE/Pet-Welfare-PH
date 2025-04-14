import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class PetForRescueView extends StatefulWidget {
  const PetForRescueView({Key? key}) : super(key: key);

  @override
  RescueState createState() => RescueState();
}

class RescueState extends State<PetForRescueView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of RescueShelterView
    return Scaffold(
        body: Center(child: Text('Find a Home: Rescue & Shelter')),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.white),
      ),
    );
  }

}