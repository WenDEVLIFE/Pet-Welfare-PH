import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  final List<String> _chipLabels = ['Pet Appreciation', 'Missing Pets', 'Found Pets',
    'Find a Home: Rescue & Shelter', 'Call for Aid', 'Paw-some Experience',
    'Pet Adoption', 'Protect Our Pets: Report Abuse', 'Caring for Pets: Vet & Travel Insights', 'Community Announcements'];
  int _selectedIndex = 0;

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600
        ),),
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
                      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white)),
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
              children: [
              Center(child: Text('Pet Appreciation')),
              Center(child: Text('Missing Pets')),
              Center(child: Text('Found Pets')),
              Center(child: Text('Find a Home: Rescue & Shelter')),
              Center(child: Text('Call for Aid')),
              Center(child: Text('Paw-some Experience')),
              Center(child: Text('Pet Adoption')),
              Center(child: Text('Protect Our Pets: Report Abuse')),
              Center(child: Text('Caring for Pets: Vet & Travel Insights')),
              Center(child: Text('Community Announcements')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}