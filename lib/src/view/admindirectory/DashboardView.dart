import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/view_model/DashboardViewModel.dart';
import '../../widgets/DrawerHeaderWidget.dart';
import '../../widgets/LogoutDialog.dart';
import '../../utils/AppColors.dart';
import '../../utils/Route.dart';
import 'package:provider/provider.dart';

// Dashboard View
class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).initDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.dashboard);
          }),
          _buildDrawerItem(Icons.verified_user_rounded, 'Users', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.userView);
          }),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.homescreen);
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.subscription);
          }),
          _buildDrawerItem(Icons.holiday_village_outlined, 'All Business', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.adminViewEstablishment);
          }),
          _buildDrawerItem(Icons.report_gmailerrorred_sharp, 'Reports', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.reportView);
          }),
          _buildDrawerItem(Icons.info, 'About us', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.about);
            // Navigate to Privacy Policy
          }),
          _buildDrawerItem(Icons.check, 'Terms and Condition', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.termsAndConditions);
          }),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
          }),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutDialog(
                  onLogout: () async {
                    await SessionManager().clearUserInfo();
                    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                    print('User logged out');
                  },
                );
              },
            );
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
            fontSize: 24, // Slightly larger for better presence
            fontWeight: FontWeight.bold, // Bolder
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
        elevation: 4, // Add a subtle shadow to the app bar
      ),
      // Use a Consumer to rebuild the UI when data changes
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          // Create a list of items to display in the grid
          final List<Map<String, dynamic>> dashboardItems = [
            {'title': 'Total Users', 'icon': Icons.person_outline, 'value': viewModel.totalUser, 'color': Colors.blue},
            {'title': 'Total Posts', 'icon': Icons.post_add_outlined, 'value': viewModel.totalPost, 'color': Colors.green},
            {'title': 'Banned Users', 'icon': Icons.block_flipped, 'value': viewModel.totalBannedUser, 'color': Colors.red},
            {'title': 'Verified Users', 'icon': Icons.verified_user_outlined, 'value': viewModel.totalApprovedUser, 'color': Colors.teal},
            {'title': 'Pending Users', 'icon': Icons.hourglass_top_outlined, 'value': viewModel.totalPendingUser, 'color': Colors.amber},
          ];

          return GridView.builder(
            padding: const EdgeInsets.all(16.0), // Padding for the entire grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              crossAxisSpacing: 16.0, // Spacing between cards horizontally
              mainAxisSpacing: 16.0, // Spacing between cards vertically
              childAspectRatio: 1.0, // Makes the cards square
            ),
            itemCount: dashboardItems.length,
            itemBuilder: (context, index) {
              final item = dashboardItems[index];
              return _buildDashboardCard(
                title: item['title'],
                icon: item['icon'],
                value: item['value'],
                color: item['color'],
              );
            },
          );
        },
      ),
    );
  }

  // The redesigned, modern dashboard card
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required int? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon with a colored background circle
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            // The main content: value and title
            value == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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