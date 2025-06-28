import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
import '../widgets/LogoutDialog.dart';
import '../model/MenuList.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import 'package:provider/provider.dart';

class MenuListWidget extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.perm_device_information, title: 'User Information'),
    MenuItem(icon: Icons.password, title: 'Change Password'),
    MenuItem(icon: Icons.notifications_active, title: 'Notifications'),
    MenuItem(icon: Icons.check, title: 'Terms and Conditions'),
    MenuItem(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy'),
    MenuItem(icon: Icons.info_outline, title: 'About Us'),
    MenuItem(icon: Icons.info_outline, title: 'My Subscription'),
    MenuItem(icon: Icons.logout, title: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
  
    final MenuViewModel menuViewModel = Provider.of<MenuViewModel>(context, listen: false);
    return Column(
      children: [
        Flexible(
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
                    Navigator.pushNamed(context, AppRoutes.viewUserInformation);
                  } else if (index == 1) {
                    // Change Password
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  } else if (index == 2) {
                    // Notifications
                    Navigator.pushNamed(context, AppRoutes.notification);

                  }
                   else if (index == 3) {
                    // Terms And Conditions
                    Navigator.pushNamed(context, AppRoutes.termsAndConditions);
                  }
                  else if (index == 4) {
                    // Privacy Policy
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                  } else if (index == 5) {
                    // About Us
                    Navigator.pushNamed(context, AppRoutes.about);
                  }
                  else if (index == 6) {

                    // Open the user subscription modal
                    menuViewModel.openUserSubscription(context);
                  }
                  else if (index == 7) {
                    // Logout
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutDialog(
                          onLogout: () async {
                            await SessionManager().clearUserInfo();
                            Provider.of<MessageViewModel>(context, listen: false).clearChatData();
                            Navigator.of(context).pop(); // Close the dialog
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