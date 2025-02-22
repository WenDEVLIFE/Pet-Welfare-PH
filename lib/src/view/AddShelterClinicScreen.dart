import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddShelterClinic extends StatelessWidget {
  const AddShelterClinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Shelter & Clinic',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text('Add Shelter/Clinic'),
      ),
    );
  }
}