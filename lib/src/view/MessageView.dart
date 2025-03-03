import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

class MessageView extends StatelessWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(width: 10),
            Text('John Doe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 20,  // Example message count
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