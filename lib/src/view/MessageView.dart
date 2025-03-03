import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<MessageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final messageViewModel = Provider.of<MessageViewModel>(context, listen: false);
    final Map<String, dynamic>? listdata =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (listdata == null || listdata['establishmentOwnerID'] == null) {
      ToastComponent().showMessage(Colors.red, 'Error: Missing User ID');
      return;
    }

    ToastComponent().showMessage(Colors.green, 'UUID: ${listdata['establishmentOwnerID']}');
    await messageViewModel.loadReceiver(listdata['establishmentOwnerID']);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            child: ListView.builder(
              itemCount: 20, // Example message count
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.grey[300] : Colors.blue[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Message $index',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
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
                    // Handle send message
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
