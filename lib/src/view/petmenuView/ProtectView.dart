import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class ProtectPetView extends StatefulWidget {
  const ProtectPetView({Key? key}) : super(key: key);

  @override
  ProtectPetState createState() => ProtectPetState();
}

class ProtectPetState extends State<ProtectPetView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(child: Text('Protect Our Pets: Report Abuse')),
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