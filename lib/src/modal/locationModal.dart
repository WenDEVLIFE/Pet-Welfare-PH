import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class locationModal {

  void ShowLocationModal(BuildContext context, Map<String , dynamic> maps) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {

      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      return Container(
        height: screenHeight * 0.3,
        decoration: const BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('Address: ${maps['display_name']!}', style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
              ),),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text('Latitude: ${maps['lat']!}\n Longitude: ${maps['lon']!}', style:
                const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                ),),
            ),
            Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.black),
              ),
              child: const Text('Close', style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
              ),),
            ),),
          ],
        ),
      );
    });
  }
}