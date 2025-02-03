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
      buildNavItem(0, Icons.home),
      buildNavItem(1, Icons.search),
      buildNavItem(2, Icons.person),
    ];
  }

  @override
  List<Widget> getPageViewChildren() {
    return [
      Container(color: Colors.yellow), // User Home
      Container(color: Colors.orange), // User Search
      Container(color: Colors.purple), // User Profile
    ];
  }
}