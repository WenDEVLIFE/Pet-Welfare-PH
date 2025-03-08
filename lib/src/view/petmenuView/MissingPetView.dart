import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class MissingPetView extends StatefulWidget {
  const MissingPetView({Key? key}) : super(key: key);

  @override
  MissingState createState() => MissingState();
}

class MissingState extends State<MissingPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of MissingPetView
    return Scaffold(
        body: Center(child: Text('Missing Pets')),
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