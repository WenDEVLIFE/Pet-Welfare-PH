import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

abstract class SubscriptionRespository {
  Future<bool> checkIfSubscriptionExist(String subscriptionName);
  Future<void> addSubscription(Map<String, dynamic> subscriptionData, BuildContext context, void Function() clearTextFields);

}

class SubscriptinImpl extends SubscriptionRespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if subscription exist
  @override
  Future<bool> checkIfSubscriptionExist(String subscriptionName) async {
    try {
      final QuerySnapshot subscriptionResult = await _firestore
          .collection('Subscription')
          .where('SubscriptionName', isEqualTo: subscriptionName)
          .get();
      return subscriptionResult.docs.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Add subscription
  @override
  Future<void> addSubscription(Map<String, dynamic> subscriptionData, BuildContext context,void Function() clearTextFields ) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Adding Subscription');
   try {
     await _firestore.collection('Subscription').add(subscriptionData);
      clearTextFields();
     Fluttertoast.showToast(
       msg: 'Subscription Added',
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.green,
       textColor: Colors.white,
       fontSize: 16.0,
     );
   } catch (e) {
     print(e);
   }
   finally {
     pd.close();
   }
  }


}