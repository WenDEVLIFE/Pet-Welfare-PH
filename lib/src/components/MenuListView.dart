import 'package:flutter/material.dart';
import '../model/MenuList.dart';

class MenuListWidget extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.home, title: 'User Information'),
    MenuItem(icon: Icons.person, title: 'Change Password'),
    MenuItem(icon: Icons.notifications, title: 'Terms and Conditions'),
    MenuItem(icon: Icons.logout, title: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(menuItems[index].icon),
          title: Text(menuItems[index].title),
          onTap: () {
            // Handle menu item tap
            if (index == 0) {
              // User Information
            } else if (index == 1) {
              // Change Password
            } else if (index == 2) {
              // Terms and Conditions
            } else if (index == 3) {
              // Logout
            }
          },
        );
      },
    );
  }
}