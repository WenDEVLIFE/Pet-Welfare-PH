import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SubscriptionRespository {

}

class SubscriptinImpl extends SubscriptionRespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> checkIfSubscriptionExist(String subscriptionName) async {
    final QuerySnapshot nameResult = await _firestore
        .collection('Subscription')
        .where('SubscriptionName', isEqualTo: subscriptionName)
        .get();
    return nameResult.docs.isNotEmpty;
  }


}