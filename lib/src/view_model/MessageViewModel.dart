import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String selectedImagePath = '';
  String receiverName = '';
  String storedMessage = '';
  String uid = '';

  final MessageRepository messageRepository = MessageRepositoryImpl();
  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final SessionManager sessionManager = SessionManager();
  List<MessageModel> _latestStreamMessages = [];

  List<MessageModel> get messages => _latestStreamMessages;
  List<ChatModel> _chats = [];
  List<ChatModel> filteredChats = [];

  // Firestore message stream
  Stream<List<MessageModel>>? messagesStream;

  Stream<List<ChatModel>> get chatsStream => messageRepository.getChat();

  // Load the receiver's profile
  Future<void> loadReceiver(String uid) async {
    try {
      this.uid = uid;

      messagesStream = messageRepository.getMessage(uid);
      listenToMessages(); // start listening

      var profileData = await _loadprofilerespository.loadProfile2(uid).first;
      if (profileData != null) {
        receiverName = profileData['name'] ?? "";
        ImageReceiver = profileData['profilepath'] ?? "";

        ToastComponent()
            .showMessage(Colors.green, 'Loaded Profile: $receiverName');
        notifyListeners();
      } else {
        ToastComponent().showMessage(Colors.red, 'Profile data is null');
      }
    } catch (e) {
      ToastComponent().showMessage(Colors.red, 'Error loading profile: $e');
    }
  }

  // Firestore messages realtime
  void listenToMessages() {
    messagesStream?.listen((messages) {
      _latestStreamMessages = messages;
      notifyListeners();
    });
  }

  // Send a message to the user
  Future<void> sendMessage(String uid) async {
    if (messageController.text.isEmpty && selectedImagePath.isEmpty) {
      ToastComponent().showMessage(Colors.red, 'Message cannot be empty');
      return;
    }

    storedMessage = messageController.text;

    try {

      messageController.clear();
      removeSelectedImage();

      // Push message to Firestore
      await messageRepository.sendMessage({
        'receiverID': uid,
        'content': storedMessage,
        'image': selectedImagePath,
        'status': 'sent',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // After sending, clear input
      storedMessage = '';
    } catch (e) {
      ToastComponent().showMessage(Colors.red, 'Error sending: $e');
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
            chats.lastMessage.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Get the messages
  void setChats(List<ChatModel> chats, {bool notify = true}) {
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

  // Clear messages
  void clearChatData() {
    messages.clear();
    _chats.clear();
    filteredChats.clear();
    ImageReceiver = '';
    selectedImagePath = '';
    receiverName = '';
    uid = '';
    messagesStream = null;
    messageController.clear();
    searchMessageController.clear();
    notifyListeners();
  }
}
