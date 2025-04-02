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

    Stream<List<DocumentSnapshot>>? notificationStream = _fetchNotificationStream(userid);

    if (notificationStream == null) {
      await Future.delayed(const Duration(seconds: 2));
      notificationStream = _fetchNotificationStream(userid);
    }

    if (notificationStream != null) {
      yield* notificationStream;
    } else {
      yield [];
    }
  }

  Stream<List<DocumentSnapshot>>? _fetchNotificationStream(String userid) {
    return _firestore.collection('NotificationCollection')
        .where('userID', isEqualTo: userid)
        .where('isRead', isEqualTo: false) // Assuming there's an 'isRead' field
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in snapshot.docs) {
          // Schedule a notification for immediate display
          NotificationUtils.scheduleNotification(
            id: doc['notificationID'].hashCode, // Unique Notification ID
            title: 'New Notification: ${doc['category']}',
            body: doc['content'],
            scheduledTime: DateTime.now().add(Duration(seconds: 5)), // Schedule for 5 seconds later
          );

          // Mark notifications as read
          doc.reference.update({'isRead': true});
        }
      }
      return snapshot.docs;
    });
  }
}