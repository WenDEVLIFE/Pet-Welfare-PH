import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import '../../widgets/DrawerHeaderWidget.dart';
import '../../widgets/LogoutDialog.dart';
import '../../utils/AppColors.dart';
import '../../utils/Route.dart';

// Dashboard View
class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context);
            // Navigate to Home
          }),
          _buildDrawerItem(Icons.verified_user_rounded, 'Users', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.userView);
            // Navigate to Verified Users
          }),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.homescreen);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.subscription);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.holiday_village_outlined, 'All Business', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.adminViewEstablishment);
          }),
          _buildDrawerItem(Icons.report_gmailerrorred_sharp, 'Reports', () {
            Navigator.pop(context);
             Navigator.pushReplacementNamed(context, AppRoutes.reportView);
          }),
          _buildDrawerItem(Icons.info, 'About us', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.about);
            // Navigate to Privacy Policy
          }),
          _buildDrawerItem(Icons.check, 'Terms and Condition', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            // Navigate to Terms and Conditions
          }),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            // Navigate to Privacy Policy
          }),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutDialog(
                  onLogout: () async {
                    // Perform logout action here
                     await SessionManager().clearUserInfo();

                     Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);

                    print('User logged out');
                  },
                );
              },
            );
            // Navigate to Logout
          }),
        ],
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Welcome to the Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SmoochSans',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Card(
                      color: AppColors.orange,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.person, color: Colors.white),
                                Text('Total Users',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Card(
                      color: AppColors.orange,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.post_add, color: Colors.white),
                                Text('Total Posts',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Card(
                      color: AppColors.orange,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.person_off, color: Colors.white),
                                Text('Total Banned Users',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Card(
                      color: AppColors.orange,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.verified_user_rounded, color: Colors.white),
                                Text('Total Verified User',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Card(
                      color: AppColors.orange,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.person_off_sharp, color: Colors.white),
                                Text('Total Unverified User',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method for building drawer items
  // Reusable method for building drawer items
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }
}