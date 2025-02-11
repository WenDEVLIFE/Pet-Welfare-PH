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
      navigationBar: const CupertinoNavigationBar(
        leading: Text('Menu', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: AppColors.orange,
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox.fromSize(size: Size.fromHeight(screenHeight * 0.02)),
              Center(
                child: Container(
                  child: Stack(
                    children: [
                      Consumer<MenuViewModel>(
                        builder: (context, viewModel, child) {
                          return CircleAvatar(
                            radius: 100,
                            backgroundColor: AppColors.orange,
                            child: CircleAvatar(
                              radius: 95,
                              backgroundImage: NetworkImage(viewModel.currentfilepath),
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
                            onPressed: () => context.read<MenuViewModel>().pickImage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.fromSize(size: Size.fromHeight(screenHeight * 0.02)),
              Center(
                child: Consumer<MenuViewModel>(
                  builder: (context, viewModel, child) {
                    return Text("Name: ${viewModel.name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              SizedBox.fromSize(size: Size.fromHeight(screenHeight * 0.02)),
              Center(
                child: Consumer<MenuViewModel>(
                  builder: (context, viewModel, child) {
                    return Text("Email: ${viewModel.email}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height, // Ensure proper layout constraints
                child: MenuListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}