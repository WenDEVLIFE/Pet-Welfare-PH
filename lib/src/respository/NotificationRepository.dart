import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:pet_welfrare_ph/src/utils/NotificationUtils.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionManager _sessionManager = SessionManager();

  Stream<List<DocumentSnapshot>> getNotificationsStream() async* {
    User? user = _auth.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    String id = user.uid;
    final userdata = await _sessionManager.getUserInfo();
    String userid = userdata?['uid'];
    if (userdata == null) {
      yield [];
      return;
    }

    yield* _firestore.collection('NotificationCollection')
        .where('userID', isEqualTo: userid)
        .where('isRead', isEqualTo: false) // Assuming there's an 'isRead' field
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        NotificationUtils.showNotification(
          id: 0, // Notification ID
          title: 'New Notifications',
          body: 'You have new notifications',
        );

        // Mark notifications as read
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.update({'isRead': true});
        }
      }
      return snapshot.docs;
    });
  }
}