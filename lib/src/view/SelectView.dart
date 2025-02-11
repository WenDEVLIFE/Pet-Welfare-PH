import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/SelectViewModel.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  late SelectViewModel selectViewModel;

  @override
  void initState() {
    super.initState();
    selectViewModel = Provider.of<SelectViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.orange,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.25,
                        child: const Image(
                          image: AssetImage('assets/icon/Logo.png'),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Center(
                        child: Text(
                          'SELECT YOUR USER CLASSIFICATION FOR REGISTRATION',
                          style: TextStyle(
                            fontSize: 35,
                            color: AppColors.white,
                            fontFamily: 'SmoochSans',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Provider.of<SelectViewModel>(context, listen: false).navigateToFuRegistration(context);
                                  },
                                  child: const Text(
                                    'Adopter, Foster, & Pet lover',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SmoochSans',
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {
                                    Provider.of<SelectViewModel>(context, listen: false).navigateToShelterRegistration(context);
                                  },
                                  child: const Text(
                                    'Pet Rescuer & Shelter',
                                    style: TextStyle(
                                      fontFamily: 'SmoochSans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {
                                    Provider.of<SelectViewModel>(context, listen: false).navigateToClinicRegistration(context);
                                  },
                                  child: const Text(
                                    'Vet Clinic Personnel',
                                    style: TextStyle(
                                      fontFamily: 'SmoochSans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {
                                    Provider.of<SelectViewModel>(context, listen: false).navigateToAffiliateLaw(context);
                                  },
                                  child: const Text(
                                    'Animal Welfare Advocates',
                                    style: TextStyle(
                                      fontFamily: 'SmoochSans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}