import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';

import 'dart:io';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<MessageView> {
  late Map<String, dynamic> listdata;
  late String userid;
  final ScrollController _scrollController = ScrollController(); // Add ScrollController

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final messageViewModel = Provider.of<MessageViewModel>(context, listen: false);
    listdata = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;

    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;

    userid = user.uid;

    if (listdata['receiverID'] == null) {
      ToastComponent().showMessage(Colors.red, 'Error: Missing User ID');
      return;
    }

    ToastComponent().showMessage(Colors.green, 'UUID: ${listdata['receiverID']}');
    await messageViewModel.loadReceiver(listdata['receiverID']);

    // Scroll to bottom after loading messages
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: Consumer<MessageViewModel>(
          builder: (context, messageViewModel, child) {
            return Row(
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.03,
                  backgroundImage: messageViewModel.ImageReceiver.isNotEmpty
                      ? CachedNetworkImageProvider(messageViewModel.ImageReceiver)
                      : null,
                  child: messageViewModel.ImageReceiver.isEmpty
                      ? Icon(Icons.person, size: screenHeight * 0.03)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  messageViewModel.receiverName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            Consumer<MessageViewModel>(
  builder: (context, vm, child) {
    final stream = vm.messagesStream;

    if (stream == null) {
      return const Center(child: CircularProgressIndicator()); // ✅ Show loading
    }

    return StreamBuilder<List<MessageModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages'));
        } else {
          final messages = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          return ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: message.senderid == userid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message.senderid == userid
                                  ? Colors.blue[300]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.height * 0.03,
                                        backgroundImage: message.senderProfileImage.isNotEmpty
                                            ? CachedNetworkImageProvider(message.senderProfileImage)
                                            : null,
                                        child: message.senderProfileImage.isEmpty
                                            ? Icon(Icons.person, size: MediaQuery.of(context).size.height * 0.03)
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        message.senderName,
                                        style: TextStyle(
                                          color: message.senderid == userid ? Colors.white : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SmoochSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: message.imageMessagePath.isNotEmpty
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          message.imageMessagePath,
                                          height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                    onTap: () {
                                      List<String> imageUrls = [message.imageMessagePath];
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.viewImageData,
                                        arguments: {
                                          'imageUrls':imageUrls,
                                          'initialIndex': 0,
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  message.message,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SmoochSans',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  message.timestamp,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'SmoochSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
          );
        }
      },
      
    );
  },
  ),
),
          Consumer<MessageViewModel>(
            builder: (context, messageViewModel, child) {
              return messageViewModel.selectedImagePath.isNotEmpty
                  ? Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Image.file(
                    File(messageViewModel.selectedImagePath),
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      messageViewModel.removeSelectedImage();
                    },
                  ),
                ],
              )
                  : Container();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    Provider.of<MessageViewModel>(context, listen: false).pickImage();
                  },
                ),
                Expanded(
                  child: CustomTextField(
                      controller: Provider.of<MessageViewModel>(context).messageController,
                      screenHeight: screenHeight,
                      hintText: 'Type your message here',
                      fontSize: 16,
                      keyboardType: TextInputType.text
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    ProgressDialog pd = ProgressDialog(context: context);
                    pd.show(
                      backgroundColor: AppColors.orange,
                      max: 100,
                      msg: 'Sending message...',
                    );
                    try {
                      await Provider.of<MessageViewModel>(context, listen: false).sendMessage(listdata['receiverID']);
                      ToastComponent().showMessage(AppColors.orange, 'Message sent successfully');
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom()); // Scroll to bottom after sending message
                    } catch (e) {
                      ToastComponent().showMessage(Colors.red, 'Error: $e');
                    } finally {
                      pd.close();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}