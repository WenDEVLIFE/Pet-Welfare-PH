import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetAdoptionView extends StatefulWidget {
  const PetAdoptionView({Key? key}) : super(key: key);

  @override
  PetAdoptionState createState() => PetAdoptionState();
}

class PetAdoptionState extends State<PetAdoptionView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of PetAdoptionView
    return const Scaffold(
        body: Center(child: Text('Pet Adoption'))
    );
  }

}