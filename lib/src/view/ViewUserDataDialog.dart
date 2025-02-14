import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/UserModel.dart';

import '../utils/AppColors.dart';

class ViewUserDataPage extends StatefulWidget {
  const ViewUserDataPage({Key? key}) : super(key: key);

  @override
  _ViewUserDataPageState createState() => _ViewUserDataPageState();
}

class _ViewUserDataPageState extends State<ViewUserDataPage> {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final Map<String, dynamic>? userData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print(userData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View User Information',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: userData?['name']),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: TextEditingController(text: userData?['email']),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: TextEditingController(text: userData?['role']),
              decoration: const InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            if (userData?['role'].toLowerCase() != 'admin') ...[
              const Text(
                'ID Front',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(
                  userData?['idfronturl'] ?? '', // Replace with your image URL
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              const Text(
                'ID Back',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(
                  userData?['idbackurl'] ?? '', // Replace with your image URL
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: screenHeight * 0.005),
             if (userData?['role'].toLowerCase() == 'Pet Rescuer' || userData?['role'].toLowerCase() == 'Pet Shelter') ...[
               TextField(
                  controller: TextEditingController(text: userData?['address']),
                 decoration: const InputDecoration(
                   labelText: 'Address',
                   labelStyle: TextStyle(
                     color: AppColors.black,
                     fontFamily: 'SmoochSans',
                     fontWeight: FontWeight.w600,
                     fontSize: 16,
                   ),
                   enabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.black),
                   ),
                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.black),
                   ),
                 ),
                 style: const TextStyle(
                   color: AppColors.black,
                   fontFamily: 'SmoochSans',
                   fontWeight: FontWeight.w600,
                   fontSize: 16,
                 ),
               ),
            ],
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
                   // Provider.of<OTPViewModel>(context, listen: false).checkOTP(int.parse(_viewModel.controllers.map((controller) => controller.text).join()), userData ,context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Approved',
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
                    // Provider.of<OTPViewModel>(context, listen: false).checkOTP(int.parse(_viewModel.controllers.map((controller) => controller.text).join()), userData ,context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Denied',
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
                    // Provider.of<OTPViewModel>(context, listen: false).checkOTP(int.parse(_viewModel.controllers.map((controller) => controller.text).join()), userData ,context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Ban User',
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update the user details
          // Implement the save functionality here
        },
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.save, color: AppColors.white),
      ),
    );
  }
}