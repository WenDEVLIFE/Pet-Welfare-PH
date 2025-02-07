import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(color: AppColors.orange),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/cat.jpg'),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: AppColors.black,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.verified_user_rounded, color: Colors.green),
                ],
              ),
              Text(
                'Super Admin',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}