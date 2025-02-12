import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/utils/ImageUtils.dart';
import 'package:pet_welfrare_ph/src/view_model/UploadIDViewModel.dart';
import '../utils/AppColors.dart';

class UploadIDView extends StatefulWidget {
  const UploadIDView({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<UploadIDView> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final Map<String, dynamic>? userData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

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
                            child: Text('Upload ID',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                )),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'Select ID Type',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<UploadIDViewModel>(
                            builder: (context, viewModel, child) {
                              return Container(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.08,
                                decoration: BoxDecoration(
                                  color: AppColors.gray,
                                  border: Border.all(color: AppColors.gray, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: DropdownButton<String>(
                                  value: viewModel.selectedIdType,
                                  items: viewModel.idType
                                      .map<DropdownMenuItem<String>>(
                                          (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SmoochSans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    viewModel.updateIdType(newValue!);
                                  },
                                  dropdownColor: AppColors.gray,
                                  iconEnabledColor: Colors.grey,
                                  isExpanded: true,
                                  alignment: Alignment.bottomLeft,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'ID Front',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Stack(
                              children: [
                                Consumer<UploadIDViewModel>(
                                  builder: (context, viewModel, child) {
                                    return CircleAvatar(
                                      radius: 100,
                                      backgroundColor: AppColors.orange,
                                      child: CircleAvatar(
                                        radius: 95,
                                        backgroundImage: viewModel.frontImagePath.isNotEmpty
                                            ? FileImage(File(viewModel.frontImagePath))
                                            : const AssetImage(ImageUtils.catPath) as ImageProvider,

                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.photo_camera),
                                      onPressed: () =>
                                          context.read<UploadIDViewModel>().pickImage(true),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'ID Back',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SmoochSans',
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Stack(
                              children: [
                                Consumer<UploadIDViewModel>(
                                  builder: (context, viewModel, child) {
                                    return CircleAvatar(
                                      radius: 100,
                                      backgroundColor: AppColors.orange,
                                      child: CircleAvatar(
                                        radius: 95,
                                        backgroundImage: viewModel.backImagePath.isNotEmpty
                                            ? FileImage(File(viewModel.backImagePath))
                                            : const AssetImage(ImageUtils.catPath) as ImageProvider,
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.photo_camera),
                                      onPressed: () =>
                                          context.read<UploadIDViewModel>().pickImage(false),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                               if(userData?['role'] == 'Pet Shelter' || userData?['role'] == 'Pet Rescuer'){
                                 var userData1 = {
                                   'email': userData?['email'],
                                   'name': userData?['name'],
                                   'password': userData?['password'],
                                   'role': userData?['role'],
                                   'address': userData?['address'],
                                 };
                                 context.read<UploadIDViewModel>().navigateToOTP(context, userData1);
                               }
                               else{
                                  var userData1 = {
                                    'email': userData?['email'],
                                    'name': userData?['name'],
                                    'password': userData?['password'],
                                    'role': userData?['role'],
                                  };
                                 context.read<UploadIDViewModel>().navigateToOTP(context ,userData1);
                               }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                              child: const Text(
                                'Proceed',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
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
