import 'package:flutter/material.dart';
import '../components/DrawerHeaderWidget.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';



// Dashboard View
class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context);
            // Navigate to Home
          }),
          _buildDrawerItem(Icons.verified_user_rounded, 'Verified Users', () {
            Navigator.pop(context);
            // Navigate to Verified Users
          }),
          _buildDrawerItem(Icons.person_off_sharp, 'Pending User Verification', () {
            Navigator.pop(context);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.homescreen);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.check, 'Terms and Condition', () {
            Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            Navigator.pop(context);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            Navigator.pop(context);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            Navigator.pop(context);
            // Navigate to Pending User Verification
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
      body: const Center(child: Text('Dashboard View')),
    );
  }

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
