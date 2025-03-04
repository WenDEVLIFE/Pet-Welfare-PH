class ChatModel{
  final String id;
  final String name;
  final String profilepath;
  final String lastMessage;
  final String senderID;
  final String receiverID;


  ChatModel({
    required this.id,
    required this.name,
    required this.profilepath,
    required this.lastMessage,
    required this.senderID,
    required this.receiverID,
  });
}