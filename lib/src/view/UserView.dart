import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/components/AlertMenuDialog.dart';
import 'package:pet_welfrare_ph/src/model/UserModel.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/UserViewModel.dart';
import '../components/DrawerHeaderWidget.dart';
import '../components/LogoutDialog.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import 'package:provider/provider.dart';

import 'BanDialogInformation.dart';
import 'ViewUserDataDialog.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _chipLabels = ['Verified User', 'Unverified User', 'Banned User', 'Admin & Sub Admin'];
  int _selectedIndex = 0;
  late var user;
  late var role;

  late UserViewModel _userViewModel;

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _searchController.addListener(() {
      _userViewModel.filterUser(_searchController.text);
    });
    getAdminData();
  }

  Future<void> getAdminData() async {
    user = await sessionManager.getUserInfo();
    role = user['role'];

    print('Details: $user');
  }

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _userViewModel.filterByStatus(index);
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
          }),
          _buildDrawerItem(Icons.verified_user_rounded, 'Users', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.userView);
          }),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.homescreen);
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.subscription);
          }),
          _buildDrawerItem(Icons.report_gmailerrorred_sharp, 'Reports', () {
            Navigator.pop(context);
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
          'Users',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.005),
          Container(
            width: screenWidth * 0.99,
            height: screenHeight * 0.08,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent, width: 7),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent, width: 2),
                ),
                hintText: 'Search a name or email....',
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              ),
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            child: Consumer<UserViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  itemCount: viewModel.getUser.length,
                  itemBuilder: (context, index) {
                    UserModel user = viewModel.getUser[index];
                    bool isBanned = user.status?.toLowerCase() == 'banned';

                    return Card(
                      color: isBanned ? Colors.red : AppColors.orange,
                      child: ListTile(
                        title: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'SmoochSans',
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Role: ${user.role}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Email: ${user.email}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'SmoochSans',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // Check if user is banned
                            if (isBanned) ...[
                              IconButton(
                                icon: const Icon(Icons.visibility, color: Colors.white),
                                onPressed: () {
                                  BanDialogInformation(
                                    userId: user.uid,
                                    userName: user.name,
                                    userEmail: user.email,
                                  ).showBanDialog(context);
                                },
                              ),


                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  Alertmenudialog.show(
                                    context,
                                    onAction: () {
                                     // Provider.of<UserViewModel>(context, listen: false).unbanUser(user.uid);
                                    },
                                    title: 'Unban User',
                                    content: 'Are you sure you want to unban this user?',
                                  );
                                },
                              ),
                            ]

                            // Check if user is not banned
                            else ...[
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  if (user.role != 'Admin' || user.role != 'Sub-Admin') {
                                    Navigator.pushNamed(context, AppRoutes.viewUserData, arguments: {
                                      'name': user.name,
                                      'email': user.email,
                                      'role': user.role,
                                      'status': user.status,
                                      'id': user.uid,
                                      'address': user.address,
                                      'profileurl': user.profileUrl,
                                      'idfronturl': user.idfrontPath,
                                      'idbackurl': user.idbackPath,
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  Alertmenudialog.show(
                                    context,
                                    onAction: () {
                                      Provider.of<UserViewModel>(context, listen: false).executeDelete(user.uid);
                                    },
                                    title: 'Delete User',
                                    content: 'Are you sure you want to delete this user?',
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Provider.of<UserViewModel>(context, listen: false).navigateToAddAdmin(context);
                },
                backgroundColor: AppColors.orange,
                child: const Icon(Icons.add, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

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