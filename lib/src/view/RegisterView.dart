import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/LoginViewModel.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                                child: Text('Register', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black)),
                              ),
                              const SizedBox(height: 20),
                              const Text('EMAIL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('PASSWORD', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                              const SizedBox(height: 10),

                              // Consumer widget
                              Consumer<LoginViewModel>(
                                builder: (context, loginViewModel, child) {
                                  return TextField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.gray,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          loginViewModel.obscureText1 ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          loginViewModel.togglePasswordVisibility1();
                                        },
                                      ),
                                      hintText: 'Enter your password',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    obscureText: loginViewModel.obscureText1,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
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
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text('Sign In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
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
                                    onTap: () {},
                                    child: const Text(
                                      'Sign up here',
                                      style: TextStyle(
                                        fontSize: 18,
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