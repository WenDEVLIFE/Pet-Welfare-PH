import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  CommunityState createState() => CommunityState();
}

class CommunityState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of the Community Announcements view
    return const Scaffold(
        body: Center(child: Text('Community Announcements'))
    );
  }

}