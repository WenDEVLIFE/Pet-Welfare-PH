
// Reusable Navigation Drawer
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final List<Widget> children;

  const NavigationDrawer({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: children),
    );
  }
}
