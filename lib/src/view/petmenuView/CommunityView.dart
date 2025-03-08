import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  CommunityState createState() => CommunityState();
}

class CommunityState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of the Community Announcements view
    return Scaffold(
        body: Center(child: Text('Community Announcements')),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

}