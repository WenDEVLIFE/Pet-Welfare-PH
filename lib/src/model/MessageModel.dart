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
}