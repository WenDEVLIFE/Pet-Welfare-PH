import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';
import '../utils/Route.dart';
import '../view_model/MapViewModel.dart';

class EstablismentModal {
  void ShowEstablismentModal(BuildContext context, Map<String, dynamic> maps, MapViewModel mapViewModel) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  // Allow the modal to expand to full height
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: screenWidth * 0.2,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child:CircleAvatar(
                        radius: screenHeight * 0.07,
                        backgroundColor: AppColors.black,
                        child: CircleAvatar(
                          radius: screenHeight * 0.068,
                          backgroundImage: CachedNetworkImageProvider(maps['establishmentImage']!),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ListTile(
                      leading: const Icon(Icons.home_work_outlined, color: Colors.white),
                      title: Text(
                        '${maps['establishmentName']!}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.white),
                      title: Text(
                        '${maps['establishmentDescription']!}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        '${maps['establishmentAddress']!}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.white),
                      title: Text(
                        '${maps['establishmentContact']!}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.white),
                      title: Text(
                        '${maps['establishmentEmail']!}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child:
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.message);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(AppColors.black),
                            ),
                            child: const Text(
                              'Chat with owner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'SmoochSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}