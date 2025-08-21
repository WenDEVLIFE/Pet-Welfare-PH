import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:provider/provider.dart';
import '../../utils/AppColors.dart';



// This is where the MessageView is defined. It displays a chat interface for messaging between users.
class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<MessageView> {
  late Map<String, dynamic> listdata;
  late String userid;
  final FocusNode _focusNode = FocusNode();
  int? expandedIndex;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    userid = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> _loadData() async {
    final messageViewModel =
        Provider.of<MessageViewModel>(context, listen: false);
    listdata =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;

    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;

    userid = user.uid;

    if (listdata['receiverID'] == null) {
      ToastComponent().showMessage(Colors.red, 'Error: Missing User ID');
      return;
    }

    await messageViewModel.loadReceiver(listdata['receiverID']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

    String formatTimestamp(DateTime date) {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return "Now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24 && date.day == now.day) {
        return "${difference.inHours}h ago";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays}d ago";
      } else if (difference.inDays < 30) {
        return "Last week";
      } else if (difference.inDays < 365) {
        return "Last month";
      } else {
        return "${date.year}/${date.month}/${date.day}";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        elevation: 2,
        title: Consumer<MessageViewModel>(
          builder: (context, messageViewModel, child) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: messageViewModel.ImageReceiver.isNotEmpty
                      ? CachedNetworkImageProvider(
                          messageViewModel.ImageReceiver)
                      : null,
                  child: messageViewModel.ImageReceiver.isEmpty
                      ? const Icon(Icons.person, size: 22)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  messageViewModel.receiverName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Messages List ---
            Expanded(
              child: Consumer<MessageViewModel>(
                builder: (context, vm, child) {
                  final messages = vm.messages;

                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderid == userid;

                      DateTime sentTime =
                          DateTime.tryParse(message.timestamp) ??
                              DateTime.now();

                      // 👇 Check if this bubble is expanded
                      bool isExpanded = expandedIndex == index;

                      // Compare with previous message for timestamp separator
                      String currentTimeLabel = formatTimestamp(sentTime);
                      String? previousTimeLabel;

                      if (index > 0) {
                        final prevMessage = messages[index - 1];
                        DateTime prevSentTime =
                            DateTime.tryParse(prevMessage.timestamp) ??
                                DateTime.now();
                        previousTimeLabel = formatTimestamp(prevSentTime);
                      }

                      bool showTimestamp =
                          currentTimeLabel != previousTimeLabel;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex =
                                (expandedIndex == index) ? null : index;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // 🕒 Timestamp Separator (not repeated)
                            if (showTimestamp)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    currentTimeLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),

                            // 💬 Chat bubble
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                padding: const EdgeInsets.all(10),
                                constraints:
                                    BoxConstraints(maxWidth: screenWidth * 0.7),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppColors.orange.withValues(alpha: 0.9)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isMe ? 16 : 0),
                                    bottomRight: Radius.circular(isMe ? 0 : 16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (message
                                        .imageMessagePath.isNotEmpty) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          message.imageMessagePath,
                                          height: screenHeight * 0.25,
                                          width: screenWidth * 0.6,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    if (message.message.isNotEmpty)
                                      Text(
                                        message.message,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            // ✅ Status / Sent timestamp
                            if (isMe && message.status == 'sending') ...[
                              Text(
                                "Sending...",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.orange[300],
                                ),
                              ),
                            ] else if (isMe &&
                                message.status == 'sent' &&
                                isExpanded) ...[
                              Text(
                                "Sent • ${sentTime.toLocal()}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ] else if (message.status == 'sent' &&
                                isExpanded) ...[
                              Text(
                                "Sent on • ${sentTime.toLocal()}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // --- Bottom Input Bar ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, size: 26, color: Colors.grey),
                    onPressed: () {
                      Provider.of<MessageViewModel>(context, listen: false)
                          .pickImage();
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        focusNode: _focusNode,
                        controller: Provider.of<MessageViewModel>(context,
                                listen: false)
                            .messageController,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 15),
                        onTap: () {
                          // auto-scroll when keyboard opens
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _scrollToBottom();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 22),
                      onPressed: () async {
                        await Provider.of<MessageViewModel>(context,
                                listen: false)
                            .sendMessage(listdata['receiverID']);
                        _scrollToBottom();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
