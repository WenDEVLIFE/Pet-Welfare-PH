import 'package:flutter/material.dart';
import '../components/LogoutDialog.dart';
import '../model/MenuList.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';

class MenuListWidget extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.perm_device_information, title: 'User Information'),
    MenuItem(icon: Icons.password, title: 'Change Password'),
    MenuItem(icon: Icons.check, title: 'Terms and Conditions'),
    MenuItem(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy'),
    MenuItem(icon: Icons.info_outline, title: 'About Us'),
    MenuItem(icon: Icons.logout, title: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(menuItems[index].icon, color: AppColors.black, size: 22,),
                title: Text(menuItems[index].title,
                  style: const TextStyle(fontSize: 18,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Handle menu item tap
                  if (index == 0) {
                    // User Information
                    Navigator.pushReplacementNamed(context, AppRoutes.viewUserInformation);
                  } else if (index == 1) {
                    // Change Password
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  } else if (index == 2) {
                    // Terms and Conditions
                    Navigator.pushNamed(context, AppRoutes.termsAndConditions);
                  } else if (index == 3) {
                    // Privacy Policy
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                  } else if (index == 4) {
                    // About Us
                    Navigator.pushNamed(context, AppRoutes.about);
                  } else if (index == 5) {
                    // Logout
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutDialog(
                          onLogout: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            await SessionManager().clearUserInfo();
                            Navigator.pushNamed(context, AppRoutes.loginScreen);
                          },
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}