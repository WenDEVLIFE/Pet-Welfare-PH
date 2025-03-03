import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';
import 'package:pet_welfrare_ph/src/respository/LoadProfileRespository.dart';
import 'package:pet_welfrare_ph/src/respository/MessageRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

class MessageViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();

  String ImageReceiver = '';
  String receiverName = '';

  final MessageRepository messageRepository = MessageRepositoryImpl();
  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();

  List<MessageModel> _messages = [];

  Stream<List<MessageModel>> get messagesStream => messageRepository.getMessage();

  Future<void> loadReceiver(String uid) async {
    try {
      var profileData = await _loadprofilerespository.loadProfile2(uid).first;
      if (profileData != null) {
        receiverName = profileData['name'] ?? "";
        ImageReceiver = profileData['profilepath'] ?? "";

        ToastComponent().showMessage(Colors.green, 'Loaded Profile: $receiverName');
        notifyListeners();
      } else {
        ToastComponent().showMessage(Colors.red, 'Profile data is null');
      }
    } catch (e) {
      ToastComponent().showMessage(Colors.red, 'Error loading profile: $e');
    }
  }
}
