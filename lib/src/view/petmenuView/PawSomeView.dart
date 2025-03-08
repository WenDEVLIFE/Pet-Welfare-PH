import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class PawSomeView extends StatefulWidget {
  const PawSomeView({Key? key}) : super(key: key);

  @override
  PawState createState() => PawState();
}

class PawState extends State<PawSomeView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of PawSomeView
    return Scaffold(
        body: Center(child: Text('Paw-some Experience')),
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