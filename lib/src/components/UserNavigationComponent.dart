import 'package:flutter/material.dart';

import 'BaseNavigationComponent.dart';

class UserNavigationComponent extends BaseNavigationComponent {
  const UserNavigationComponent({Key? key}) : super(key: key);

  @override
  _UserNavigationComponentState createState() => _UserNavigationComponentState();
}

class _UserNavigationComponentState extends BaseNavigationComponentState<UserNavigationComponent> {
  @override
  List<Widget> getNavBarItems() {
    return [
      buildNavItem(0, Icons.home, "Home"),
      buildNavItem(1, Icons.map, "Map"),
      buildNavItem(2, Icons.person_pin, "Profile"),
      buildNavItem(3, Icons.menu, "Menu"),
    ];
  }

  @override
  List<Widget> getPageViewChildren() {
    return [
      Container(color: Colors.yellow), // User Home
      Container(color: Colors.orange), // User Search
      Container(color: Colors.purple), // User Profile
      Container(color: Colors.green), // User Menu
    ];
  }
}