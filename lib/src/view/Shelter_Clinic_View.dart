import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';
import '../utils/Route.dart';

class Shelter_Clinic_View extends StatefulWidget {
  const Shelter_Clinic_View({Key? key}) : super(key: key);

  @override
  Shelter_Clinic_ViewState createState() => Shelter_Clinic_ViewState();
}

class Shelter_Clinic_ViewState  extends State<Shelter_Clinic_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Shelter & Clinic',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: const Center(
        child: Text('Shelter/Clinic'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.addSherterClinic);
        },
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: AppColors.orange,),
      ),
    );
  }
}