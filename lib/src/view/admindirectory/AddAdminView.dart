import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/AddAdminViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomPasswordField.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../../utils/AppColors.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({Key? key}) : super(key: key);

  @override
  AddAdminViewState createState() => AddAdminViewState();

}

class AddAdminViewState extends State<AddAdminView> {



  late AddAdminViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<AddAdminViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Admin',
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
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'EMAIL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              CustomTextField(
                controller: viewModel.email,
                screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  hintText: 'Enter the email address',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'NAME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              CustomTextField(
                controller: viewModel.name,
                screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  hintText: 'Enter full name',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text('SELECT YOUR USER CLASSIFICATION',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SmoochSans',
                      color: Colors.black)),
              SizedBox(height: screenHeight * 0.01),
              Consumer(
                builder: (context, AddAdminViewModel viewModel, child) {
                  return Container(
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
                        items: viewModel.adminRole.map<DropdownMenuItem<String>>((String value) {
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
                          viewModel.setSelectedRole(newValue);
                        },
                        dropdownColor: AppColors.gray,
                        iconEnabledColor: Colors.grey,
                        style: const TextStyle(color: Colors.white),
                        selectedItemBuilder: (BuildContext context) {
                          return viewModel.adminRole.map<Widget>((String item) {
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
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'PASSWORD',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomPasswordField(screenHeight: screenHeight,
                  hintText: 'Enter the password',
                  controller: viewModel.password,
                  isPasswordVisible: viewModel.obscureText1,
                  togglePasswordVisibility: viewModel.togglePasswordVisibility1
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'CONFIRM PASSWORD',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              CustomPasswordField(screenHeight: screenHeight,
                  hintText: 'Re-enter the password',
                  controller: viewModel.confirmpassword,
                  isPasswordVisible: viewModel.obscureText2,
                  togglePasswordVisibility: viewModel.togglePasswordVisibility2
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
                      Provider.of<AddAdminViewModel>(context, listen: false).checkData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Add User',
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