import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/UserDataViewModel.dart';
import 'package:provider/provider.dart';

class ChangeIDView extends StatefulWidget {
  const ChangeIDView({Key? key}) : super(key: key);

  @override
  IDState createState() => IDState();
}

class IDState extends State<ChangeIDView> {
  late UserDataViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<UserDataViewModel>(context, listen: false);
    Provider.of<UserDataViewModel>(context, listen: false).loadSelectedIDType();
    if (viewModel.selectedIdType.isEmpty && viewModel.idType1.isNotEmpty) {

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Upload ID',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        Consumer<UserDataViewModel>(
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
                                items: viewModel.idType1
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
                              Consumer<UserDataViewModel>(
                                builder: (context, viewModel, child) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundColor: AppColors.orange,
                                    child: CircleAvatar(
                                      radius: 95,
                                      backgroundImage: viewModel.frontImagePath.isNotEmpty
                                          ? FileImage(File(viewModel.frontImagePath))
                                          : viewModel.idfrontpath.isNotEmpty
                                          ? NetworkImage(viewModel.idfrontpath) as ImageProvider<Object>?
                                          : null,
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
                                        context.read<UserDataViewModel>().pickImage(true),
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
                              Consumer<UserDataViewModel>(
                                builder: (context, viewModel, child) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundColor: AppColors.orange,
                                    child: CircleAvatar(
                                      radius: 95,
                                      backgroundImage: viewModel.backImagePath.isNotEmpty
                                          ? FileImage(File(viewModel.backImagePath))
                                          : viewModel.idbackpath.isNotEmpty
                                          ? NetworkImage(viewModel.idbackpath) as ImageProvider<Object>?
                                          : null,
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
                                        context.read<UserDataViewModel>().pickImage(false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                            child: const Text(
                              'Update ID',
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
          ],
        ),
      ),
    );
  }
}