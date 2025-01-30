import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  _SelectViewState createState() => _SelectViewState();

}

class _SelectViewState extends State<SelectView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}