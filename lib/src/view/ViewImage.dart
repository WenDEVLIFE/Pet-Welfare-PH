import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

class ViewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var imageData = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    List<String> imageUrls = imageData['imageUrls'];
    int initialIndex = imageData['initialIndex'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Center(
          child: CustomText(
            text:  imageUrls.length > 1 ? '${initialIndex + 1} / ${imageUrls.length}' : '',
            size: 16,
            color: AppColors.white,
            weight: FontWeight.w600,
            align: TextAlign.center,
            screenHeight: screenHeight,
            alignment: Alignment.centerLeft,
          ),
        ),
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
        child: Container(
          height: screenHeight * 0.8,
          width: screenWidth * 0.8,
          child: PageView.builder(
            itemCount: imageUrls.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        )
      ),
    );
  }
}