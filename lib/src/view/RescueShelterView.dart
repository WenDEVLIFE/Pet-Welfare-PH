import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RescueShelterView extends StatefulWidget {
  const RescueShelterView({Key? key}) : super(key: key);

  @override
  RescueState createState() => RescueState();
}

class RescueState extends State<RescueShelterView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of RescueShelterView
    return const Scaffold(
        body: Center(child: Text('Find a Home: Rescue & Shelter'))
    );
  }

}