import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../model/SubcriptionModel.dart';
import 'package:intl/intl.dart';

abstract class SubscriptionRespository {
  Future<bool> checkIfSubscriptionExist(String subscriptionName);
  Future<void> addSubscription(Map<String, dynamic> subscriptionData, BuildContext context, void Function() clearTextFields);
  Stream<List<SubscriptionModel>> getSubscriptions();
  Future<void> updateSubscriptionData(Map<String, String> subscriptionData, BuildContext context, String uid);
  void deleteSubscription(BuildContext context, String uid);

  Future <String> getUserSubscriptionName();

  Future <String> getUserSubscriptionPrice(String subscriptionName);

  Future <String> getUserSubscriptionDuration();

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
  Future<void> addSubscription(Map<String, dynamic> subscriptionData, BuildContext context, void Function() clearTextFields) async {
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
    } finally {
      pd.close();
    }
  }

  // Get subscriptions
  @override
  Stream<List<SubscriptionModel>> getSubscriptions() {
    return _firestore.collection('Subscription').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SubscriptionModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  // Update subscription
  @override
  Future<void> updateSubscriptionData(Map<String, String> subscriptionData, BuildContext context, String uid) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Updating Subscription');
    try {
      await _firestore.collection('Subscription').doc(uid).update({
        'SubscriptionName': subscriptionData['SubscriptionName'],
        'SubscriptionDuration': subscriptionData['SubscriptionDuration'],
        'SubscriptionPrice': subscriptionData['SubscriptionPrice'],
      });
      Fluttertoast.showToast(
        msg: 'Subscription Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to update subscription',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      pd.close();
    }
  }
  void deleteSubscription(BuildContext context, String uid) {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Deleting Subscription');
    try {
      _firestore.collection('Subscription').doc(uid).delete();
      Fluttertoast.showToast(
        msg: 'Subscription Deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to delete subscription',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      pd.close();
    }
  }

  @override
  Future<String> getUserSubscriptionName() async {
    User user = FirebaseAuth.instance.currentUser!;

    String uid = user.uid;

    try {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        return doc['SubscriptionType'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }

  }

  @override
  Future<String> getUserSubscriptionPrice(String SubscriptionName) async {
    User user = FirebaseAuth.instance.currentUser!;

    String uid = user.uid;

    try {
      DocumentSnapshot doc = await _firestore.collection('Subscription').where('SubscriptionName', isEqualTo: SubscriptionName).get().then((snapshot) => snapshot.docs.first);
      if (doc.exists) {
        return doc['SubscriptionPrice'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Future<String> getUserSubscriptionDuration() async {
    User user = FirebaseAuth.instance.currentUser!;
    String uid = user.uid;

    try {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        Timestamp? expiresAt = doc['SubscriptionExpiresAt'];
        if (expiresAt != null) {
          DateTime dateTime = expiresAt.toDate();
          return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        }
        return '';
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

}