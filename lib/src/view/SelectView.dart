import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.orange,
        ),
        child:  Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                          image: AssetImage('assets/icon/Logo.png'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select a registeration type',
                        style: TextStyle(
                          fontSize: 40,
                          color: AppColors.white,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                  )),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {


                                  },
                                  child: const Text(
                                    'Affiliated to Legal Firms',
                                    style: TextStyle(
                                      fontFamily: 'SmoochSans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {


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
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                  onPressed: () {


                                  },
                                  child: const Text(
                                    'Vet Clinic',
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