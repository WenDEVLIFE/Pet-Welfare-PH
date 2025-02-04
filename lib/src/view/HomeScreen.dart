import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: AppColors.orange,
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen'),
      ),
    );
  }

}