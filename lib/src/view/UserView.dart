import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/UserViewModel.dart';
import '../components/DrawerHeaderWidget.dart';
import '../components/LogoutDialog.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import '../view_model/AddAdminViewModel.dart';
import 'package:provider/provider.dart';


class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _chipLabels = ['Verified User', 'Unverified User', 'Banned User', 'Admin & Sub Admin'];
  int _selectedIndex = 0;

  late UserViewModel _userViewModel;

  @override
  void initState() {
    super.initState();
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
            Navigator.pushNamed(context, AppRoutes.homescreen);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.subscription);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.check, 'Terms and Condition', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            // Navigate to Pending User Verification
          }),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            // Navigate to Pending User Verification
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
          'Users',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
        iconTheme: IconThemeData(color: Colors.white), // Ensure icon color is set
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.005),
          Container(
            width: screenWidth * 0.99, // Set the width of the TextField container
            height: screenHeight * 0.08, // Adjust the height of the TextField container
            padding: const EdgeInsets.symmetric(horizontal: 10.0), // Optional padding for the container
            decoration: BoxDecoration(
              color: Colors.transparent, // Background color of the TextField container
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent, width: 7), // Border color of the container
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.black), // Search icon inside the TextField
                fillColor: Colors.grey[200], // Set the background color here
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent, width: 2), // Adjust border thickness
                ),
                hintText: 'Search a name or email....',
                hintStyle: const TextStyle(
                  color: Colors.black, // Set the hint text color here
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0), // Remove or reduce inner padding
              ),
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                color: Colors.black, // Set the text color here
                fontSize: 16, // Set the text size here
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.005), // Reduce the space between the TextField and the chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the padding around the chips
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _chipLabels.asMap().entries.map((entry) {
                  int index = entry.key;
                  String label = entry.value;
                  bool isSelected = _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      label: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: isSelected ? AppColors.orange : AppColors.black,
                      onPressed: () {
                        _updateContent(index);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_selectedIndex == 0) ...[
                      const Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Verified Users',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    if (_selectedIndex == 1) ...[
                      const Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Unverified Users',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    if (_selectedIndex == 2) ...[
                      const Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Banned Users',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    if (_selectedIndex == 3) ...[
                      const Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Admin & Sub Admin',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontFamily: 'SmoochSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // Add your onPressed logic here
                  Provider.of<UserViewModel>(context, listen: false).navigateToAddAdmin(context);
                },
                backgroundColor: AppColors.orange,
                child: const Icon(Icons.add, color: AppColors.white,),
              ),
            ),
          ),
        ],
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