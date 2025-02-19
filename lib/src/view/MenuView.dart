import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
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
            Flexible(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.2, // Set to 30% of screen height
                color: AppColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<MenuViewModel>(
                          builder: (context, viewModel, child) {
                            return CircleAvatar(
                              radius: 50, // Adjust size as needed
                              backgroundColor: AppColors.black,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(viewModel.currentfilepath),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 12.0),
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
                            SizedBox(height: 4.0),
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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