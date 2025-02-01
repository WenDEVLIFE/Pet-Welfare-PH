import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/LoginViewModel.dart';

class VetClinicRegisterView extends StatefulWidget {
  const VetClinicRegisterView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<VetClinicRegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late RegisterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<RegisterViewModel>(context, listen: false);
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
                            child: Text('SIGN UP FOR VET CLINIC PERSONNEL',
                                style: TextStyle(fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black)),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.gray,
                              border: OutlineInputBorder(),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SmoochSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'SmoochSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('EMAIL', style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.gray,
                              border: OutlineInputBorder(),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SmoochSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'SmoochSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('PASSWORD', style:
                          TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black
                          )),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<RegisterViewModel>(
                            builder: (context, viewmodel, child) {
                              return TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      viewmodel.obscureText1 ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      viewmodel.togglePasswordVisibility1();
                                    },
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SmoochSans',
                                  ),
                                ),
                                obscureText: viewmodel.obscureText1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('CONFIRM PASSWORD', style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<RegisterViewModel>(
                            builder: (context, viewmodel, child) {
                              return TextField(
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      viewmodel.obscureText2 ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      viewmodel.togglePasswordVisibility2();
                                    },
                                  ),
                                  hintText: 'Enter confirm password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SmoochSans',
                                  ),
                                ),
                                obscureText: viewmodel.obscureText2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Consumer<RegisterViewModel>(
                            builder: (context, viewmodel, child) {
                              return CheckboxListTile(
                                title: const Text(
                                  'I agree to the terms and conditions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SmoochSans',
                                  ),
                                ),
                                value: viewmodel.isChecked,
                                onChanged: (bool? value) {
                                  viewmodel.setChecked(value!);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: Colors.red,
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
                                  Provider.of<RegisterViewModel>(context, listen: false).proceedUploadID(context);
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
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Align(
                              alignment: const Alignment(0.0, 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<RegisterViewModel>(context, listen: false).showTermsAndConditionDialog(context);
                                },
                                child: const Text(
                                  'Click here to view terms and conditions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SmoochSans',
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
                                onTap: () {
                                  Provider.of<RegisterViewModel>(context, listen: false).proceedLogin(context);
                                },
                                child: const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
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
                                onTap: () {
                                  Provider.of<RegisterViewModel>(context, listen: false).proceedLogin(context);
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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