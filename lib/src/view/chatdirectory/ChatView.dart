
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:pet_welfrare_ph/src/model/ChatModel.dart';

import '../../Animation/MessageShimmer.dart';
import '../../utils/Route.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    MessageViewModel messageViewModel = Provider.of<MessageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.005),
          Container(
            width: screenWidth * 0.99,
            height: screenHeight * 0.08,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.transparent, width: 7),
            ),
            child: TextField(
              controller: messageViewModel.searchMessageController,
              onChanged: (query) {
                messageViewModel.filterChats(query);
              },
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent, width: 2),
                ),
                hintText: 'Search a Message....',
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              ),
              style: const TextStyle(
                fontFamily: 'SmoochSans',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: messageViewModel.chatsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MessageShimmer(width: screenWidth * 0.99, height: screenHeight * 0.2);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Chats found'));
                } else {
                  List<ChatModel> chatrooms = snapshot.data!;
                  if (messageViewModel.filteredChats.isEmpty) {
                    messageViewModel.setChats(chatrooms);
                  }
                  return ListView.builder(
                    itemCount: messageViewModel.filteredChats.length,
                    itemBuilder: (context, index) {
                      ChatModel chat = messageViewModel.filteredChats[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(chat.profilepath),
                        ),
                        title: Text(chat.name),
                        subtitle: Text(chat.lastMessage),
                        onTap: () {
                          // Get current user's ID
                          final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                          // Determine which ID is the other user (not current user)
                          final otherUserId = currentUserId == chat.senderID
                              ? chat.receiverID
                              : chat.senderID;

                          Navigator.pushNamed(context, AppRoutes.message, arguments: {
                            'receiverID': otherUserId
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}