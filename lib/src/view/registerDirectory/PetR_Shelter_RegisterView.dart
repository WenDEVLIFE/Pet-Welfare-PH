import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import '../../utils/AppColors.dart';
import '../TermsAndConditionDialog.dart';
import '../../view_model/LoginViewModel.dart';

class PetrShelterRegisterview extends StatefulWidget {
  const PetrShelterRegisterview({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<PetrShelterRegisterview> {
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
                            child: Text('SIGN UP FOR PET SHELTER & RESCUE',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black)),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextField(
                            controller: viewModel.nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.gray,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.transparent, width: 2),
                              ),
                              hintText: 'Enter your name',
                              hintStyle: const TextStyle(
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
                          const Text('EMAIL', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          TextField(
                            controller: viewModel.emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.gray,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.transparent, width: 2),
                              ),
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
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
                          const Text('SELECT YOUR USER CLASSIFICATION',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.08,
                            decoration: BoxDecoration(
                              color: AppColors.gray,
                              border: Border.all(color: AppColors.gray, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.grey[800],
                              ),
                              child: DropdownButton<String>(
                                value: viewModel.selectedRole,
                                items: viewModel.role.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SmoochSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    viewModel.selectedRole = newValue!;
                                  });
                                },
                                dropdownColor: AppColors.gray,
                                iconEnabledColor: Colors.grey,
                                style: const TextStyle(color: Colors.white),
                                selectedItemBuilder: (BuildContext context) {
                                  return viewModel.role.map<Widget>((String item) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'SmoochSans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                isExpanded: true,
                                alignment: Alignment.bottomLeft,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text('ADDRESS', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          TextField(
                            controller: viewModel.addressController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.gray,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.transparent, width: 2),
                              ),
                              hintText: 'Enter your address',
                              hintStyle: const TextStyle(
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
                          const Text('PASSWORD', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<RegisterViewModel>(
                            builder: (context, viewmodel, child) {
                              return TextField(
                                controller: viewmodel.passwordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                  ),
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
                          const Text('CONFIRM PASSWORD', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black)),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<RegisterViewModel>(
                            builder: (context, viewmodel, child) {
                              return TextField(
                                controller: viewmodel.confirmPasswordController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                  ),
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
                                  Provider.of<RegisterViewModel>(context, listen: false).checkData(context, viewModel.selectedRole);
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