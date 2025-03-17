import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
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
  String selectedImagePath= '';
  String receiverName = '';

  final MessageRepository messageRepository = MessageRepositoryImpl();
  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final SessionManager sessionManager = SessionManager();
  List<MessageModel> _messages = [];
  List<ChatModel> _chats = [];
  List<ChatModel> filteredChats = [];

  Stream<List<MessageModel>> get messagesStream => messageRepository.getMessage();
  Stream<List<ChatModel>> get chatsStream => messageRepository.getChat();

  // Load the receiver's profile
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

  // Send a message to the user
  Future<void> sendMessage(String uid) async {
    if (messageController.text.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Message cannot be empty');
      return;
    } else {
      Map<String, dynamic> message = {
        'receiverID': uid,
        'content': messageController.text,
        'image': selectedImagePath,
      };
      await messageRepository.sendMessage(message);
      messageController.clear();
      removeSelectedImage();
    }
  }

  // Initialize the chats
  Future<void> initializeChats() async {
    var userdata = await sessionManager.getUserInfo();
    var role = userdata?['role'];
    if (role != null) {
      messageRepository.getChat().listen((event) {
        print('Chat data: $event');
      });
    }
  }

  // Filter the chats
  void filterChats(String query) {
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

  // Get the messages
  void setChats(List<ChatModel> chats) {
    _chats = chats;
    filterChats(searchMessageController.text);
  }

  // Select an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath = image.path;
      notifyListeners();
    }
  }

  // Remove the selected Image
  void removeSelectedImage() {
    selectedImagePath = '';
    notifyListeners();
  }
}