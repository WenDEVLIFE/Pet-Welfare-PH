import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/OTPViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../utils/OTPField.dart';

class OTPView extends StatefulWidget {
  const OTPView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<OTPView> {
  late OTPViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OTPViewModel>(context, listen: false);
    _viewModel.startTimer();
    _viewModel.generateOTP(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.25,
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
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Center(
                            child: Text('Verification Code',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black)),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('Enter the Verification Code',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black,
                            ),
                          ),
                          OTPField(controllers: _viewModel.controllers),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<OTPViewModel>(
                            builder: (context, viewModel, child) {
                              return Center(
                                child: Text(
                                  viewModel.time == 0 ? '' : 'Resend verification code in ${viewModel.time} seconds',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontFamily: 'SmoochSans',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
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
                                  Provider.of<OTPViewModel>(context, listen: false).checkOTP(int.parse(_viewModel.controllers.map((controller) => controller.text).join()));
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
                          SizedBox(height: screenHeight * 0.02),
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
                                  if (_viewModel.time == 0) {
                                    _viewModel.generateOTP(context);
                                    _viewModel.resetTimer();
                                    _viewModel.startTimer();
                                  } else {
                                    // show snackbar
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('Resend Code',
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
                        ],
                      ),
                    ),
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