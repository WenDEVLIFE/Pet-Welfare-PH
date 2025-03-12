import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String message;
  String timestamp;
  String senderid;
  String receiverid;
  String receiverName;
  String receiverProfileImage;
  String senderName;
  String senderProfileImage;

  MessageModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.senderid,
    required this.receiverid,
    this.receiverName = '',
    this.receiverProfileImage = '',
    this.senderName = '',
    this.senderProfileImage = '',
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

  static Future<MessageModel> fromDocumentSnapshotWithUserData(DocumentSnapshot doc) async {
    var message = MessageModel.fromDocumentSnapshot(doc);

    var senderDoc = await FirebaseFirestore.instance.collection('Users').doc(message.senderid).get();
    var receiverDoc = await FirebaseFirestore.instance.collection('Users').doc(message.receiverid).get();

    message.senderName = senderDoc['Name'] ?? '';
    message.senderProfileImage = senderDoc['ProfileUrl'] ?? '';
    message.receiverName = receiverDoc['Name'] ?? '';
    message.receiverProfileImage = receiverDoc['ProfileUrl'] ?? '';

    return message;
  }
}