
import 'package:flutter/material.dart';

import 'BaseNavigationComponent.dart';


class AdminNavigationWidget extends BaseNavigationWidget {
  const AdminNavigationWidget ({Key? key}) : super(key: key);

  @override
  _AdminNavigationComponentState createState() => _AdminNavigationComponentState();
}

class _AdminNavigationComponentState extends BaseNavigationComponentState<AdminNavigationWidget> {
  @override
  List<Widget> getNavBarItems() {
    return [
      buildNavItem(0, Icons.dashboard, "Dashboard"),
      buildNavItem(1, Icons.person , "Users"),
      buildNavItem(2, Icons.menu , "Home"),
      buildNavItem(3, Icons.menu , "Menu"),
    ];
  }

  @override
  List<Widget> getPageViewChildren() {
    return [
      Container(color: Colors.red), // Admin Dashboard
      Container(color: Colors.green), // Admin Settings
      Container(color: Colors.blue), // Admin Panel
      Container(color: Colors.yellow), // Admin Menu
    ];
  }
}