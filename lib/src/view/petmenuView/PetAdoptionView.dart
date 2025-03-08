import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class PetAdoptionView extends StatefulWidget {
  const PetAdoptionView({Key? key}) : super(key: key);

  @override
  PetAdoptionState createState() => PetAdoptionState();
}

class PetAdoptionState extends State<PetAdoptionView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of PetAdoptionView
    return Scaffold(
        body: Center(child: Text('Pet Adoption')),
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