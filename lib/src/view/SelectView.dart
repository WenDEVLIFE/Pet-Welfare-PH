import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  _SelectViewState createState() => _SelectViewState();

}

class _SelectViewState extends State<SelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.orange,
        ),
        child: const Column(  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select View', style:
            TextStyle(
              fontSize: 30,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.bold,
            ),
            ),
          ],
        ),
      ),
    );
  }
}