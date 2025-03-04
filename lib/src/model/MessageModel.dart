import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String id;
  String message;
  String timestamp;
  String senderid;
  String receiverid;


  MessageModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.senderid,
    required this.receiverid,
  });

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return MessageModel(
      id: doc.id,
      message: doc['Message'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp?)?.toDate().toString() ?? '',
      senderid: doc['senderID'] ?? '',
      receiverid: doc['receiverID'] ?? '',
    );
  }
}