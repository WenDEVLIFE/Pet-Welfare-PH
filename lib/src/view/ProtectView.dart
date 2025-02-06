import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProtectPetView extends StatefulWidget {
  const ProtectPetView({Key? key}) : super(key: key);

  @override
  ProtectPetState createState() => ProtectPetState();
}

class ProtectPetState extends State<ProtectPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
        body: Center(child: Text('Protect Our Pets: Report Abuse'))
    );
  }

}