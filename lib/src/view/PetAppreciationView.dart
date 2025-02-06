import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({Key? key}) : super(key: key);

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return const Scaffold(
       body: Center(child: Text('Pet Appreciation'))
   );
  }

}