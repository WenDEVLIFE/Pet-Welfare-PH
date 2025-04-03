import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_welfrare_ph/src/utils/NotificationUtils.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';

class NotificationListener1 extends StatelessWidget {
  final NotificationRepository notificationRepository = NotificationRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: notificationRepository.getNotificationsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          for (DocumentSnapshot doc in snapshot.data!) {
            NotificationUtils.showNotification(
              id: doc.id.hashCode, // Unique Notification ID
              title: 'New Notification: ${doc['category']}',
              body: doc['content'],
            );

            // Mark notifications as read
            doc.reference.update({'isRead': true});
          }
        }
        return const SizedBox.shrink(); // Return an empty widget
      },
    );
  }
}