import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallOfAidView extends StatefulWidget {
  const CallOfAidView({Key? key}) : super(key: key);

  @override
  AidState createState() => AidState();
}


class AidState extends State<CallOfAidView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build of the Call for Aid view
    return const Scaffold(
        body: Center(child: Text('Call for Aid'))
    );
  }

}