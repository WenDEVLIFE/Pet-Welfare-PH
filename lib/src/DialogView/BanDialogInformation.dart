import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class BanDialogInformation {
  final String userId;
  final String userName;
  final String userEmail;

  BanDialogInformation({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  void showBanDialog(BuildContext context) async {
    String reason = await checkDatabase(userId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.orange,
          title: Center(
            child: Text(userName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'SmoochSans',
              ),
          ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text('Reason for ban: $reason',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SmoochSans',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close',   style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'SmoochSans',
              ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> checkDatabase(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Banned')
          .where('Uid', isEqualTo: userId)
          .get().then((value) => value.docs.first);
      if (userDoc.exists) {
        return userDoc['Reason'] ?? 'No reason provided';
      } else {
        return 'User not found';
      }
    } catch (e) {
      return 'Error retrieving ban reason: $e';
    }
  }
}