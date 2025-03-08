import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class FoundPetView extends StatefulWidget {
  const FoundPetView({Key? key}) : super(key: key);

  @override
  FoundPetState createState() => FoundPetState();
}

class FoundPetState extends State<FoundPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of FoundPetView
    return Scaffold(
        body: Center(child: Text('Found Pets')),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add_location_alt_sharp, color: AppColors.white),
      ),
    );
  }

}