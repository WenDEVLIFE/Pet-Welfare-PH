import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  String uid;
  String subscriptionName;
  String subscriptionType;
  String subscriptionAmount;

  SubscriptionModel({
    required this.uid,
    required this.subscriptionName,
    required this.subscriptionType,
    required this.subscriptionAmount,
  });

  factory SubscriptionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return SubscriptionModel(
      uid: doc.id,
      subscriptionName: doc['SubscriptionName'],
      subscriptionType: doc['SubscriptionType'],
      subscriptionAmount: doc['SubscriptionAmount'],
    );
  }
}