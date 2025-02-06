import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PawSomeView extends StatefulWidget {
  const PawSomeView({Key? key}) : super(key: key);

  @override
  PawState createState() => PawState();
}

class PawState extends State<PawSomeView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of PawSomeView
    return const Scaffold(
        body: Center(child: Text('Paw-some Experience'))
    );
  }

}