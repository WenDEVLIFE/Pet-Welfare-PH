import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VetAndTravelView extends StatefulWidget {
  const VetAndTravelView({Key? key}) : super(key: key);

  @override
  VetAndTravelState createState() => VetAndTravelState();
}

class VetAndTravelState extends State<VetAndTravelView> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build of VetAndTravelView
    return const Scaffold(
        body: Center(child: Text('Caring for Pets: Vet & Travel Insights'))
    );
  }

}