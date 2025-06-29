import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import '../../utils/AppColors.dart';
import '../../view_model/LoginViewModel.dart';
import '../../widgets/CustomPasswordField.dart';
import '../../widgets/CustomTextField.dart';

class LegalFirmRegisterView extends StatefulWidget {
  const LegalFirmRegisterView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<LegalFirmRegisterView> {


  late RegisterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<RegisterViewModel>(context, listen: false);
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Center(
                              child: Text('SIGN UP FOR ANIMAL WELFARE ADVOCATE',
                                  style: TextStyle(fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'SmoochSans',
                                      color: Colors.black)),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Text('NAME', style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'SmoochSans',
                                color: Colors.black)),
                            SizedBox(height: screenHeight * 0.01),
                            CustomTextField(
                              controller: viewModel.nameController,
                              screenHeight: screenHeight,
                              hintText: 'Enter your name',
                              fontSize: 16,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Text('EMAIL', style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'SmoochSans',
                                color: Colors.black)),
                            SizedBox(height: screenHeight * 0.01),
                            CustomTextField(
                              controller: viewModel.emailController,
                              screenHeight: screenHeight,
                              hintText: 'Enter your email',
                              fontSize: 16,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Text('PASSWORD', style:
                            TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'SmoochSans',
                                color: Colors.black
                            )),
                            SizedBox(height: screenHeight * 0.01),
                            CustomPasswordField(
                              screenHeight: screenHeight,
                              hintText: 'Enter your password',
                              controller: viewModel.passwordController,
                              isPasswordVisible: viewModel.obscureText2,
                              togglePasswordVisibility: viewModel.togglePasswordVisibility1,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            const Text('CONFIRM PASSWORD', style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SmoochSans',
                                color: Colors.black)),
                            SizedBox(height: screenHeight * 0.01),
                            CustomPasswordField(
                              screenHeight: screenHeight,
                              hintText: 'Re-enter your password',
                              controller: viewModel.confirmPasswordController,
                              isPasswordVisible: viewModel.obscureText2,
                              togglePasswordVisibility: viewModel.togglePasswordVisibility2,
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
                                    Provider.of<RegisterViewModel>(context, listen: false).checkData(context, "Animal Welfare Advocate");
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
      ),
    );
  }
}