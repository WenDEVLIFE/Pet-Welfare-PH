import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/CallofAidView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/CommunityView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/FoundPetView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/MissingPetView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PawSomeView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetAdoptionView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/ProtectView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetForRescueView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetCareView.dart';
import 'package:pet_welfrare_ph/src/view/petmenuView/PetAppreciationView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  final List<String> _chipLabels = [
    'Pet Appreciation', 'Missing Pets', 'Found Pets',
    'Pets For Rescue', 'Call for Aid', 'Paw-some Experience',
    'Pet Adoption', 'Protect Our Pets: Report Abuse', 'Pet Care Insights', 'Community Announcements'
  ];
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const [
                PetAppreciateView(), // Pet Appreciation
                MissingPetView(), // Missing Pets
                FoundPetView(), // Found Pets
                PetForRescueView(), // Find a Home: Rescue & Shelter
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
}