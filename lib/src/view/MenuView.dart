import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomButton.dart';
import 'package:pet_welfrare_ph/src/widgets/TermsAndConditionDialogWidget.dart';
import '../utils/Route.dart';
import '../widgets/AlertMenuDialog.dart';
import 'MenuListView.dart';
import '../utils/AppColors.dart';
import '../utils/ImageUtils.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  MenuViewState createState() => MenuViewState();
}

class MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    // Load profile data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuViewModel>(context, listen: false).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight * 0.2, // Set to 20% of screen height
              color: AppColors.orange,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<MenuViewModel>(
                        builder: (context, viewModel, child) {
                          return GestureDetector(
                            child: CircleAvatar(
                              radius: screenHeight * 0.07,
                              backgroundColor: AppColors.black,
                              child: CircleAvatar(
                                radius: screenHeight * 0.068,
                                backgroundImage: CachedNetworkImageProvider(viewModel.currentfilepath),
                              ),
                            ),
                            onTap: () {
                              // Implement image upload functionality here
                              Navigator.pushNamed(context, AppRoutes.viewImageData, arguments: {
                                'imagePath': viewModel.currentfilepath,
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<MenuViewModel>(
                            builder: (context, viewModel, child) {
                              return Text(
                                viewModel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Consumer<MenuViewModel>(
                            builder: (context, viewModel, child) {
                              return Text(
                                viewModel.email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          Consumer<MenuViewModel>(
                            builder: (context, viewModel, child) {
                              if (viewModel.role.toLowerCase() == 'pet rescuer') {
                                return CustomButton(
                                  hint: viewModel.isLocationEnabled ? 'Unpin my location' : 'Pin my location',
                                  size: 16,
                                  color1: AppColors.black,
                                  textcolor2: AppColors.white,
                                  onPressed: () {
                                     if (viewModel.isLocationEnabled) {
                                       showDialog(context: context, builder: (context) {
                                         return Alertmenudialog(
                                           title: 'Unpin Location',
                                           content: 'Are you sure you want to unpin your location?',
                                           onAction: () {
                                             viewModel.pinRescue();
                                           },
                                         );
                                       });

                                     } else{
                                        showDialog(context: context, builder: (context) {
                                          return Alertmenudialog(
                                            title: 'Pin Location',
                                            content: 'Are you sure you want to pin your location?',
                                            onAction: () {
                                              viewModel.pinRescue();
                                            },
                                          );
                                        });
                                     }
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox.fromSize(size: Size.fromHeight(screenHeight * 0.02)),
            Expanded(
              child: MenuListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}