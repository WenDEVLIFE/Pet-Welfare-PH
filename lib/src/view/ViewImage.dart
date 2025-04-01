import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

class ViewImage extends StatefulWidget {
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  late PageController _pageController;
  late List<String> imageUrls;
  late int initialIndex;
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var imageData = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    imageUrls = imageData['imageUrls'];
    initialIndex = imageData['initialIndex'];
    currentIndex = initialIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Center(
          child: CustomText(
            text: imageUrls.length > 1 ? '${currentIndex + 1} / ${imageUrls.length}' : '',
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
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        ),
      ),
    );
  }
}