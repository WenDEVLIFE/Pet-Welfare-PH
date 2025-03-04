import 'package:pet_welfrare_ph/src/model/MessageModel.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getMessage();
  Future<void>sendMessage(Map<String, dynamic> message);


}

class MessageRepositoryImpl implements MessageRepository {
  @override
  Stream<List<MessageModel>> getMessage() {
    // TODO: implement getMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(Map<String, dynamic> message) {
    throw UnimplementedError();
  }


}

