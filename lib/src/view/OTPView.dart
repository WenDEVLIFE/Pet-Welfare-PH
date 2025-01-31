import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/UploadIDViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';


// TODO : Unifished OTPView
class OTPView extends StatefulWidget {
  const OTPView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<OTPView> {

  var time = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon/Logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Center(
                                child: Text('Verification Code',
                                    style: TextStyle(fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.black)),
                              ),
                              const Center(
                                child: Text('Verification Code has been sent to your email',
                                    style: TextStyle(fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 20),
                              const Text('Enter the Verification Code',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: screenWidth * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.transparent),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // call the controller
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text('Proceed',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SmoochSans',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}