import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/model/MessageModel.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<MessageView> {
  late Map<String, dynamic> listdata;
  late String userid;

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
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: Consumer<MessageViewModel>(
          builder: (context, messageViewModel, child) {
            return Row(
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.03,
                  backgroundImage: CachedNetworkImageProvider(messageViewModel.ImageReceiver),
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
            child: StreamBuilder<List<MessageModel>>(
              stream: Provider.of<MessageViewModel>(context).messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    // Handle image upload
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: Provider.of<MessageViewModel>(context).messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    Provider.of<MessageViewModel>(context, listen: false).sendMessage(listdata['receiverID']);
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