import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/CallofAidView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/CommunityView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/FoundPetView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/MissingPetView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PawSomeView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetAdoptionView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/ProtectView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetForRescueView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetCareView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetAppreciationView.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Post',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}