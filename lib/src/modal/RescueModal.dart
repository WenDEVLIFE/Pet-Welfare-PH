import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomButton.dart';
import 'package:provider/provider.dart';
import '../utils/Route.dart';
import '../view_model/ApplyAdoptionViewModel.dart';

class RescueModal extends StatefulWidget {
  final Map<String, dynamic> petrescuer;

  RescueModal({Key? key, required this.petrescuer}) : super(key: key);

  @override
  _PetModalState createState() => _PetModalState();
}

class _PetModalState extends State<RescueModal> {
  late Map<String, dynamic> petrescuer;

  @override
  void initState() {
    super.initState();
    petrescuer = widget.petrescuer;
  }

  @override
  Widget build(BuildContext context) {
    ApplyAdoptionViewModel createPostViewModel = Provider.of<ApplyAdoptionViewModel>(context);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( petrescuer['petName']=='Found Pets' ? 'Found Pet Details' : 'Lost Pet Details',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: screenHeight * 0.3,
                      child: PageView.builder(
                        itemCount: petrescuer['imageUrls'].length,
                        itemBuilder: (context, imageIndex) {
                          return Container(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.5,
                            child: CachedNetworkImage(
                              imageUrl: petrescuer['imageUrls'][imageIndex],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petName']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Type',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petType']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Breed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petBreed']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Gender',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petGender']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Age',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petAge']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Color',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petColor']),
                  ),
                  ListTile(
                    title: const Text(
                      'Pet Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['petAddress']),
                  ),
                  ListTile(
                    title: const Text(
                      'Region, Province, City, Barangay',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['regProCiBag']),
                  ),
                  ListTile(
                    title: Text(
                      petrescuer['petName']=='Found Pets' ? 'Date of the found pet' : 'Date of the lost pet',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['date']),
                  ),
                  ListTile(
                    title: const Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['status']),
                  ),
                  ListTile(
                    title: const Text(
                      'Latitude',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['lat'].toString()),
                  ),
                  ListTile(
                    title: const Text(
                      'Longitude',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(petrescuer['long'].toString()),
                  ),
                  ListTile(
                    subtitle: Center(
                      child: CustomButton(
                          hint: 'Message',
                          size: 16.0,
                          color1: AppColors.orange,
                          textcolor2: AppColors.white,
                          onPressed: () {
                            User user = FirebaseAuth.instance.currentUser!;
                            String uid = user.uid;

                            if (petrescuer['postOwnerID'] == uid) {
                              ToastComponent().showMessage(Colors.red, 'You cannot send a message to yourself');
                              return;
                            }

                            Navigator.pushNamed(context, AppRoutes.message, arguments:{
                              'receiverID': petrescuer['postOwnerId'],
                            });
                          }
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}