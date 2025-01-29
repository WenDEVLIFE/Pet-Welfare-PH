

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/ImageUtils.dart';

class Loginview extends StatefulWidget {
  const Loginview({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginview> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureText1 = true;
  void togglePasswordVisibility1() {
    setState(() {
      obscureText1 = !obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.orange, // Set the background color here
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 400,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageUtils.logoPath),
                      fit: BoxFit.cover, // Adjust this to control how the image fits
                    ),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'AID',
                        style: TextStyle(
                          fontSize: 40,
                          color: AppColors.white, // Color for "AID"
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: ' ANCHOR',
                        style: TextStyle(
                          fontSize: 40,
                          color: AppColors.white, // Color for "ANCHOR"
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300, // Set the desired width here
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text('LOGIN', style: TextStyle(fontSize: 30, fontFamily: 'LeagueSpartan',  fontWeight: FontWeight.w900, color: AppColors.white)),
                      ),
                      const SizedBox(height: 20),
                      const Text('EMAIL', style: TextStyle(fontSize: 18, fontFamily: 'LeagueSpartan',  fontWeight: FontWeight.w600, color: AppColors.white)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.white, // Set the background color here
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(
                            color: Colors.black, // Set the hint text color here
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'LeagueSpartan',
                          color: Colors.black, // Set the text color here
                          fontSize: 16, // Set the text size here
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('PASSWORD', style: TextStyle(fontSize: 18, fontFamily: 'LeagueSpartan',  fontWeight: FontWeight.w900, color: AppColors.white)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.white, // Set the background color here
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText1 ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility1,
                          ),
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Colors.black, // Set the hint text color here
                          ),
                        ),
                        obscureText: obscureText1,
                        style: const TextStyle(
                          color: Colors.black, // Set the text color here
                          fontFamily: 'LeagueSpartan',
                          fontSize: 16, // Set the text size here
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child:Container(
                          width: 350, // Adjust the width as needed
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Background color of the TextField
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.transparent), // Border color
                          ),
                          child: ButtonTheme(
                            minWidth: 300, // Adjust the width as needed
                            height: 100, // Adjust the height as needed
                            child: ElevatedButton(
                              onPressed: () {
                                // call the controller

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:AppColors.black, // Background color of the button
                              ),
                              child: const Text('Sign In',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.black,
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Add 20 pixels of space on the left
                        child: Align(
                          alignment: const Alignment(0.0, 0.0), // Center align
                          child: GestureDetector(
                            onTap: () {
                            },
                            child: const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.white, // Color for "AID"
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0), // Add 20 pixels of space on the left
                        child: Align(
                          alignment: const Alignment(0.0, 0.0), // Center align
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: const Text(
                              'Sign up here',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.white, // Color for "AID"
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}