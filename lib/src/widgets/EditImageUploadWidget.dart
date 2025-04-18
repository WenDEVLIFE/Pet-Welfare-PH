import 'package:flutter/material.dart';

import 'CustomText.dart';

class EditImageUploadWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<String> images; // Accept URLs as strings
  final Function() onPickImage;
  final Function(String) onRemoveImage; // Pass URL instead of File

  EditImageUploadWidget({
    required this.screenWidth,
    required this.screenHeight,
    required this.images,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: screenWidth * 0.99,
        height: screenHeight * 0.25,
        child: images.isEmpty
            ? Center(
          child: GestureDetector(
            onTap: onPickImage,
            child: Container(
              width: screenWidth * 0.2,
              height: screenHeight * 0.1,
              color: Colors.grey[200],
              child: const Icon(Icons.add_a_photo, color: Colors.grey),
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Upload a picture',
              size: 18,
              color: Colors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: screenHeight * 0.01),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (images.length < 5)
                    GestureDetector(
                      onTap: onPickImage,
                      child: Container(
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.1,
                        color: Colors.grey[200],
                        child: const Icon(Icons.add_a_photo, color: Colors.grey),
                      ),
                    ),
                  ...images.map((url) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              onRemoveImage(url);
                            },
                            child: Container(
                              color: Colors.black54,
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}