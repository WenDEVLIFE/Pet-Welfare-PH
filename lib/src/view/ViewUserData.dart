import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class ViewUserData extends StatefulWidget {
  const ViewUserData({Key? key}) : super(key: key);

  @override
  _ViewUserDataState createState() => _ViewUserDataState();
}

// TODO : Implement the state of the ViewUserData and the UI of the ViewUserData
class _ViewUserDataState extends State<ViewUserData>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.orange,
        title: const Text('My Information',
          style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          fontFamily: 'SmoochSans',
          color: Colors.black,
        ),),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [

            ],
        ),
      ),
    );
  }
}