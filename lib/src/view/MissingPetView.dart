import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MissingPetView extends StatefulWidget {
  const MissingPetView({Key? key}) : super(key: key);

  @override
  MissingState createState() => MissingState();
}

class MissingState extends State<MissingPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of MissingPetView
    return const Scaffold(
        body: Center(child: Text('Missing Pets'))
    );
  }

}