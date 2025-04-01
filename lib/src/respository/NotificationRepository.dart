import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionManager _sessionManager = SessionManager();

  Future<List<DocumentSnapshot>> getNotifications() async {
    User user = _auth.currentUser!;
    String id = user.uid;
    final userdata = await _sessionManager.getUserInfo();
    String name = userdata?['name'];
    final snapshot = await _firestore.collection('NotificationCollection')
        .where('userID', isEqualTo: id)
        .get();
    return snapshot.docs;
  }
}