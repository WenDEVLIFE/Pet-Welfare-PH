import 'package:flutter/material.dart';
import 'dart:io';

import 'CustomText.dart';

class ImageUploadWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<File> images;
  final Function() onPickImage;
  final Function(File) onRemoveImage;

  ImageUploadWidget({
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
        height: screenHeight * 0.2,
        child: SingleChildScrollView(
          child: Column(
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
                    GestureDetector(
                      onTap: onPickImage,
                      child: Container(
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.1,
                        color: Colors.grey[200],
                        child: const Icon(Icons.add_a_photo, color: Colors.grey),
                      ),
                    ),
                    ...images.map((image) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 100,
                            height: 100,
                            child: Image.file(image, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                onRemoveImage(image);
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.transparent,
                    ),
                  ),
                  CustomText(
                    text: 'Image selected: ${images.length.toString()} / 5',
                    size: 18,
                    color: Colors.black,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    screenHeight: screenHeight,
                    alignment: Alignment.centerLeft,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}