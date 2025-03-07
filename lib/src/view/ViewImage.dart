import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageData = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image' , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close , color: Colors.white),
            onPressed: () {
              // Implement share functionality here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Image.network(
            imageData['imagePath']!,
            fit: BoxFit.contain, // Ensures the image fits well
          ),
        ),
      ),
    );
  }
}
