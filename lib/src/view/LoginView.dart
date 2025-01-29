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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              color: AppColors.orange,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageUtils.logoPath),
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
                                child: Text('LOGIN', style: TextStyle(fontSize: 30, fontFamily: 'SmoochSans', fontWeight: FontWeight.w700, color: AppColors.black)),
                              ),
                              const SizedBox(height: 20),
                              const Text('EMAIL', style: TextStyle(fontSize: 18, fontFamily: 'SmoochSans', fontWeight: FontWeight.w700, color: AppColors.black)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('PASSWORD', style: TextStyle(fontSize: 18,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureText1 ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: togglePasswordVisibility1,
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                obscureText: obscureText1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                      backgroundColor: AppColors.black,
                                    ),
                                    child: const Text('Sign In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.white,
                                        fontFamily: 'SmoochSans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'SmoochSans',
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
                                    onTap: () {},
                                    child: const Text(
                                      'Sign up here',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
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