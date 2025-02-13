import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/AddAdminViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SubcriptionViewModel.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';

class AddSubscriptionView extends StatefulWidget {
  const AddSubscriptionView({Key? key}) : super(key: key);

  @override
  AddAdminViewState createState() => AddAdminViewState();

}

class AddAdminViewState extends State<AddSubscriptionView> {

  late SubscriptionViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<SubscriptionViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    // Get the screen height and width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Subscription',
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
                'Subscription Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Consumer<SubscriptionViewModel>(
                builder: (context, changeViewModel, child) {
                  return TextField(
                    controller: viewModel.subscriptionNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray,
                      border: OutlineInputBorder(),
                      hintText: 'Enter the subscription name',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
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
                'Subscription Price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Consumer<AddAdminViewModel>(
                builder: (context, changeViewModel, child) {
                  return TextField(
                    controller: viewModel.subscriptionPriceController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray,
                      border: OutlineInputBorder(),
                      hintText: 'Enter the subscription price',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
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
                'Subscription Duration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SmoochSans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Consumer<AddAdminViewModel>(
                builder: (context, changeViewModel, child) {
                  return TextField(
                    controller: viewModel.subscriptionPriceController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.gray,
                      border: OutlineInputBorder(),
                      hintText: 'Enter the subscription duration',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
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
                      Provider.of<AddAdminViewModel>(context, listen: false).checkData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Add Subscription',
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