import 'package:pet_welfrare_ph/src/model/MessageModel.dart';

abstract class MessageRepository {
  Stream<List<MessageModel>> getMessage();


}

class MessageRepositoryImpl implements MessageRepository {
  @override
  Stream<List<MessageModel>> getMessage() {
    // TODO: implement getMessage
    throw UnimplementedError();
  }


}

