import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();

}

class ProfileViewState  extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: const Center(
        child: Text('Profile View'),
      ),
    );
  }
}
