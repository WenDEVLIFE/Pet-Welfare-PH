import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
import '../components/MenuListView.dart';
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
                              backgroundImage: viewModel.currentfilepath.isNotEmpty
                                  ? FileImage(File(viewModel.currentfilepath))
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
                            onPressed: () => context.read<MenuViewModel>().pickImage(),
                          ),
                        ),
                      ),
                    ],
                  ),
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