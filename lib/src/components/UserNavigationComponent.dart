import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view/HomeScreen.dart';

import 'BaseNavigationComponent.dart';

class UserNavigationComponent extends BaseNavigationComponent {
  const UserNavigationComponent({Key? key}) : super(key: key);

  @override
  _UserNavigationComponentState createState() => _UserNavigationComponentState();
}

class _UserNavigationComponentState extends BaseNavigationComponentState<UserNavigationComponent> {
  @override

  // List of navigation items
  List<Widget> getNavBarItems() {
    return [
      buildNavItem(0, Icons.home, "Home"),
      buildNavItem(1, Icons.map, "Map"),
      buildNavItem(2, Icons.person_pin, "Profile"),
      buildNavItem(3, Icons.menu, "Menu"),
      buildNavItem(4, Icons.notifications_active, "Notifications"),
    ];
  }

  // List of page view children
  @override
  List<Widget> getPageViewChildren() {
    return [
      const HomeScreen(), // User Home
      const HomeScreen(), // User Search
      const HomeScreen(), // User Profile
      const HomeScreen(), // User Menu
      const HomeScreen(), // User Notifications
    ];
  }
}