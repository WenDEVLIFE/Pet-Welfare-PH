import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:provider/provider.dart';
import '../DialogView/ChangeProfileDialog.dart';
import '../view_model/UserDataViewModel.dart';

class ViewUserData extends StatefulWidget {
  const ViewUserData({Key? key}) : super(key: key);

  @override
  _ViewUserDataState createState() => _ViewUserDataState();
}

class _ViewUserDataState extends State<ViewUserData> {
  late UserDataViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<UserDataViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadInformation();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Information',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.2,
              color: AppColors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Consumer<UserDataViewModel>(
                      builder: (context, viewModel, child) {
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.orange,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.black,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(viewModel.profilepath),
                                ),
                              ),
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
                                  icon: const Icon(Icons.photo_camera, color: Colors.white),
                                  onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context){
                                      return const ChangeProfileDialog();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
               child: Text(
                 'Name: ${viewModel.name}',
                 style: const TextStyle(
                   color: AppColors.black,
                   fontFamily: 'SmoochSans',
                   fontWeight: FontWeight.w600,
                   fontSize: 16,
                 ),
               ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Padding(
              padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Email: ${viewModel.email}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Padding(
              padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Role: ${viewModel.role}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            if (viewModel.role.toLowerCase() != 'admin') ...[
              Padding(
                padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'ID Type: ${viewModel.idType}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'ID Front:',
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      viewModel.idfrontpath ?? '',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              if (viewModel.status == 'Pending') ...[
                Center(
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.changeID);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('Change ID Front',
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
                SizedBox(height: screenHeight * 0.005),
              ],
              SizedBox(height: screenHeight * 0.005),
              const Padding(
                padding:  EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'ID Back:',
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      viewModel.idbackpath ?? '',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
             if (viewModel.status == 'Pending') ...[
               Center(
                 child: Padding(
                   padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.pushNamed(context, AppRoutes.changeID);

                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.black,
                     ),
                     child: const Text('Change ID Back',
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
               SizedBox(height: screenHeight * 0.005),
             ],
            ],
            SizedBox(height: screenHeight * 0.005),
            if (viewModel.role == 'pet rescuer' || viewModel.role.toLowerCase() == 'pet shelter') ...[
              Padding(
                padding:  const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'Address: ${viewModel.address }',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
            ],
          ],
        ),
      ),
    );
  }
}