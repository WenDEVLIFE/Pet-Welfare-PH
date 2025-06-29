
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view/MyPostView.dart';
import 'package:pet_welfrare_ph/src/view/chatdirectory/ChatView.dart';
import 'package:pet_welfrare_ph/src/view/HomeScreen.dart';
import 'package:pet_welfrare_ph/src/view/Mapview.dart';
import 'package:pet_welfrare_ph/src/view/MenuView.dart';

import 'BaseNavigationComponent.dart';

class UserNavigationComponent extends BaseNavigationWidget {
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
      buildNavItem(2, Icons.person_pin, "My Posts"),
      buildNavItem(4, Icons.chat_sharp, "Chats"),
      buildNavItem(3, Icons.menu, "Menu"),
    ];
  }

  // List of page view children
  @override
  List<Widget> getPageViewChildren() {
    return [
      const HomeScreen(), // User Home
      const MapView(), // User Search
      const ProfileView(), // User Profile
      ChatView(), // User Menu
      const MenuView(), // User Notifications
    ];
  }
}