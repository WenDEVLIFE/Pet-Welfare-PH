import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoundPetView extends StatefulWidget {
  const FoundPetView({Key? key}) : super(key: key);

  @override
  FoundPetState createState() => FoundPetState();
}

class FoundPetState extends State<FoundPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of FoundPetView
    return const Scaffold(
        body: Center(child: Text('Found Pets'))
    );
  }

}