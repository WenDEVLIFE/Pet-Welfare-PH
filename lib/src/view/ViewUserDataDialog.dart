import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class ViewUserDataDialog extends StatelessWidget {
  final String id;

  ViewUserDataDialog({required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.orange,
      title: const Text('View User Data',
        style: TextStyle(
          color: AppColors.white,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
             // controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Subscription Name',
                labelStyle: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextField(
             // controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (days)',
                labelStyle: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextField(
             // controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Update the subscription details
            //subscription.subscriptionName = nameController.text;
            //subscription.subscriptionDuration = durationController.text;
            //subscription.subscriptionAmount = amountController.text;


            // pass the subscription data to the updateSubscription method
          //  Provider.of<SubscriptionViewModel>(context, listen: false).updateSubscription(subscriptionData, context, uid);
          },
          child: const Text('Save',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}