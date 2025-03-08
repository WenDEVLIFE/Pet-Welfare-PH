import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class CreatePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a post to share with the community',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.3,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your post here...',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.transparent, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}