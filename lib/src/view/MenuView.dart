import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/MenuListView.dart';
import '../utils/AppColors.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  MenuViewState createState() => MenuViewState();
}

class MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Menu', style: TextStyle(
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