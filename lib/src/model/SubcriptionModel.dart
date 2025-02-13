import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  String uid;
  String subscriptionName;
  String subscriptionDuration;
  String subscriptionAmount;

  SubscriptionModel({
    required this.uid,
    required this.subscriptionName,
    required this.subscriptionDuration,
    required this.subscriptionAmount,
  });

  factory SubscriptionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return SubscriptionModel(
      uid: doc.id,
      subscriptionName: doc['SubscriptionName'],
      subscriptionDuration: doc['SubscriptionDuration'],
      subscriptionAmount: doc['SubscriptionPrice'],
    );
  }
}