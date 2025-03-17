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
  String imageMessagePath = '';

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
    this.imageMessagePath='',
  });

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      message: data['Message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate().toString() ?? '',
      senderid: data['senderID'] ?? '',
      receiverid: data['receiverID'] ?? '',
      imageMessagePath: data.containsKey('imageUrl') ? data['imageUrl'] : '',
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