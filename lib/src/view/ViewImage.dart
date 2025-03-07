import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageData = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child:Expanded(
          child: Container(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: imageData['imagePath']!,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(), // Shows a loading spinner
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red), // Shows error icon if loading fails
          ),
        ),),
      ),
    );
  }
}
