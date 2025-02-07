import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/components/BaseScreen.dart';
import 'package:pet_welfrare_ph/src/view/CallofAidView.dart';
import 'package:pet_welfrare_ph/src/view/CommunityView.dart';
import 'package:pet_welfrare_ph/src/view/FoundPetView.dart';
import 'package:pet_welfrare_ph/src/view/MissingPetView.dart';
import 'package:pet_welfrare_ph/src/view/PawSomeView.dart';
import 'package:pet_welfrare_ph/src/view/PetAdoptionView.dart';
import 'package:pet_welfrare_ph/src/view/ProtectView.dart';
import 'package:pet_welfrare_ph/src/view/RescueShelterView.dart';
import 'package:pet_welfrare_ph/src/view/VetAndTravelView.dart';

import '../components/DrawerHeaderWidget.dart';
import '../utils/Route.dart';
import 'PetAppreciationView.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  final List<String> _chipLabels = ['Verified User', 'Unverified User', 'Bannded User', 'Admin & Sub Admin'];
  int _selectedIndex = 0;

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          _buildDrawerItem(Icons.verified_user_rounded, 'Users', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.userView);
            // Navigate to Verified Users
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
          'Users',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                        style: TextStyle(color: Colors.white),
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
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                PetAppreciateView(), // Pet Appreciation
                MissingPetView(), // Missing Pets
                FoundPetView(), // Found Pets
                RescueShelterView(), // Find a Home: Rescue & Shelter
                CallOfAidView(), // Call for Aid
                PawSomeView(), // Paw-some Experience
                PetAdoptionView(), // Pet Adoption
                ProtectPetView(), // Protect Our Pets: Report Abuse
                VetAndTravelView(), // Caring for Pets: Vet & Travel Insights
                CommunityView(), // Community Announcements
              ],
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