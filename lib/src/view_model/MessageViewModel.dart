import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/ChatModel.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';
import 'package:pet_welfrare_ph/src/respository/LoadProfileRespository.dart';
import 'package:pet_welfrare_ph/src/respository/MessageRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../utils/SessionManager.dart';

class MessageViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchMessageController = TextEditingController();

  String ImageReceiver = '';
  String receiverName = '';

  final MessageRepository messageRepository = MessageRepositoryImpl();
  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final SessionManager sessionManager = SessionManager();
  List<MessageModel> _messages = [];
  List<ChatModel> _chats = [];
  List<ChatModel> filteredChats = [];

  Stream<List<MessageModel>> get messagesStream => messageRepository.getMessage();
  Stream<List<ChatModel>> get chatsStream => messageRepository.getChat();

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

  Future<void> sendMessage(String uid) async {
    if (messageController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Message cannot be empty');
      return;
    } else {
      Map<String, dynamic> message = {
        'receiverID': uid,
        'content': messageController.text,
      };
      await messageRepository.sendMessage(message);
      messageController.clear();
    }
  }

  Future<void> initializeChats() async {
    var userdata = await sessionManager.getUserInfo();
    var role = userdata?['role'];
    if (role != null) {
      messageRepository.getChat().listen((event) {
        print('Chat data: $event');
      });
    }
  }

  Future<void> filteredchats(String query) async {
    // Implement filtering logic here
    if (query.isEmpty) {
      filteredChats = _chats;
    } else {
      filteredChats = _chats.where((chats) {
        return chats.name.toLowerCase().contains(query.toLowerCase()) ||
            chats.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> setChats(List<ChatModel> chats) async {
    _chats = chats;
    filteredchats(searchMessageController.text);
    notifyListeners();
  }
}