import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  final String id;
  final String content;
  final String timestamp;

  NotificationModel({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc){
    return NotificationModel(
      id: doc.id,
      content: doc['content'],
      timestamp: doc['timestamp'].toString(),
    );
  }
}