
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_model/MapViewModel.dart';


void ShowEstablismentModal(BuildContext context, Map<String , dynamic> maps, MapViewModel mapViewModel) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Bottom Sheet Content'),
              ElevatedButton(
                child: Text('Close Bottom Sheet'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}