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
  String imageMessagePath;
  String status;

  MessageModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.senderid,
    required this.receiverid,
    required this.status,
    this.receiverName = '',
    this.receiverProfileImage = '',
    this.senderName = '',
    this.senderProfileImage = '',
    this.imageMessagePath = '',
  });

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      message: data['Message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate().toString() ?? '',
      senderid: data['senderID'] ?? '',
      receiverid: data['receiverID'] ?? '',
      senderName: data['senderName'] ?? '',
      senderProfileImage: data['senderProfileImage'] ?? '',
      receiverName: data['receiverName'] ?? '',
      receiverProfileImage: data['receiverProfileImage'] ?? '',
      imageMessagePath: data.containsKey('imageUrl') ? data['imageUrl'] : '',
      status: data['status'] ?? 'sending',
    );
  }

  /// 🔑 Cache for user data to avoid re-fetching
  static final Map<String, Map<String, String>> _userCache = {};

  /// Async version (fetch from Firestore if not cached)
  static Future<MessageModel> fromDocumentSnapshotWithUserData(
      DocumentSnapshot doc) async {
    var message = MessageModel.fromDocumentSnapshot(doc);

    // Sender
    if (!_userCache.containsKey(message.senderid)) {
      var senderDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(message.senderid)
          .get();

      _userCache[message.senderid] = {
        'Name': senderDoc['Name'] ?? '',
        'ProfileUrl': senderDoc['ProfileUrl'] ?? '',
      };
    }

    // Receiver
    if (!_userCache.containsKey(message.receiverid)) {
      var receiverDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(message.receiverid)
          .get();

      _userCache[message.receiverid] = {
        'Name': receiverDoc['Name'] ?? '',
        'ProfileUrl': receiverDoc['ProfileUrl'] ?? '',
      };
    }

    // Attach cached values
    message.senderName = _userCache[message.senderid]!['Name'] ?? '';
    message.senderProfileImage =
        _userCache[message.senderid]!['ProfileUrl'] ?? '';
    message.receiverName = _userCache[message.receiverid]!['Name'] ?? '';
    message.receiverProfileImage =
        _userCache[message.receiverid]!['ProfileUrl'] ?? '';

    return message;
  }

  /// ✅ Sync version (use only cached user data)
  static MessageModel fromDocumentSnapshotWithUserDataSync(
      DocumentSnapshot doc) {
    var message = MessageModel.fromDocumentSnapshot(doc);

    if (_userCache.containsKey(message.senderid)) {
      message.senderName = _userCache[message.senderid]!['Name'] ?? '';
      message.senderProfileImage =
          _userCache[message.senderid]!['ProfileUrl'] ?? '';
    }

    if (_userCache.containsKey(message.receiverid)) {
      message.receiverName = _userCache[message.receiverid]!['Name'] ?? '';
      message.receiverProfileImage =
          _userCache[message.receiverid]!['ProfileUrl'] ?? '';
    }

    return message;
  }
}
