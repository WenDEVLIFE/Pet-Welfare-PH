
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;

  const BaseScreen({Key? key, required this.child}) : super(key: key);

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> with AutomaticKeepAliveClientMixin<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}