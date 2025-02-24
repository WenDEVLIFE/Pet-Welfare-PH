import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  //  controller: establishmentViewModel.searchController,
                  onChanged: (query) {
                    //  establishmentViewModel.filterSubscriptions(query);
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
            ],
          ),
    );
  }
}