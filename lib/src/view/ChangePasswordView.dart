import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/ChangePasswordViewModel.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordView> {
  late ChangePasswordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ChangePasswordViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Password',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.01),
              const Text(
                'OLD PASSWORD',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Consumer<ChangePasswordViewModel>(
                builder: (context, changeViewModel, child) {
                  return TextField(
                    controller: viewModel.oldPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          changeViewModel.obscureText1 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          changeViewModel.togglePasswordVisibility1();
                        },
                      ),
                      hintText: 'Enter your old password',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    obscureText: changeViewModel.obscureText1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'NEW PASSWORD',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Consumer<ChangePasswordViewModel>(
                builder: (context, changeViewModel, child) {
                  return TextField(
                    controller: viewModel.newPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          changeViewModel.obscureText2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          changeViewModel.togglePasswordVisibility2();
                        },
                      ),
                      hintText: 'Enter your new password',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    obscureText: changeViewModel.obscureText2,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
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
                      // Add your update password logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Update Password',
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
            ],
          ),
        ),
      ),
    );
  }
}