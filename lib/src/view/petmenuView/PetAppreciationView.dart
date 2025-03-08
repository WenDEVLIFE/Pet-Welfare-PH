import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';

import '../../utils/AppColors.dart';

class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({Key? key}) : super(key: key);

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
       body: const Center(child: Text('Pet Appreciation')),
     floatingActionButton:  FloatingActionButton(
       backgroundColor: AppColors.orange,
       onPressed: () {
       Navigator.pushNamed(context, AppRoutes.createpost);
       },
       child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.white),
     ),
   );
  }

}