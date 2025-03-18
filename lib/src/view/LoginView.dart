import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/LoginViewModel.dart';
import '../widgets/CustomPasswordField.dart';

class Loginview extends StatefulWidget {
  const Loginview({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginview> {

  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                            child: Text('LOGIN', style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SmoochSans',
                                color: Colors.black)),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('EMAIL', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          CustomTextField(
                            controller: loginViewModel.emailController,
                            screenHeight: screenHeight,
                            hintText: 'Enter your email',
                            fontSize: 16,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('PASSWORD', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<LoginViewModel>(
                            builder: (context, loginViewModel, child) {
                              return  CustomPasswordField(
                                screenHeight: screenHeight,
                                hintText: 'Enter your password',
                                controller: loginViewModel.passwordController,
                                isPasswordVisible: loginViewModel.obscureText1,
                                togglePasswordVisibility: loginViewModel.togglePasswordVisibility1,
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
                                  if (loginViewModel.emailController.text.isNotEmpty && loginViewModel.passwordController.text.isNotEmpty) {
                                    Provider.of<LoginViewModel>(context, listen: false).login(context);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Please fill all the fields',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('Sign In',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: const Alignment(0.0, 0.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: const Alignment(0.0, 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<LoginViewModel>(context, listen: false).navigateToSelectView(context);
                                },
                                child: const Text(
                                  'Sign up here',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
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