import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'package:pet_welfrare_ph/src/view_model/ShelterClinicViewModel.dart';
import 'package:provider/provider.dart';

import 'EditEstablishmentView.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';

class Shelter_Clinic_View extends StatefulWidget {
  const Shelter_Clinic_View({Key? key}) : super(key: key);

  @override
  Shelter_Clinic_ViewState createState() => Shelter_Clinic_ViewState();
}

class Shelter_Clinic_ViewState extends State<Shelter_Clinic_View> {
  late ShelterClinicViewModel establishmentViewModel;

  @override
  void initState() {
    super.initState();
    establishmentViewModel = Provider.of<ShelterClinicViewModel>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Shelter & Clinic',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
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
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent, width: 7),
            ),
            child: TextField(
              controller: establishmentViewModel.searchController,
              onChanged: (query) {
                establishmentViewModel.filterSubscriptions(query);
              },
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent, width: 2),
                ),
                hintText: 'Search a establishment name....',
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
          SizedBox(height: screenHeight * 0.005),
          Expanded(
            child: FutureBuilder<List<EstablishmentModel>>(
              future: establishmentViewModel.establishmentStream.first,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('No Establishment found'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Establishment available'));
                } else {
                  final establishment = snapshot.data!;
                  establishmentViewModel.setEstablishment(establishment);
                  return Consumer<ShelterClinicViewModel>(
                    builder: (context, viewModel, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                          itemCount: viewModel.establismentListdata.length,
                          itemBuilder: (context, index) {
                            EstablishmentModel establishData = viewModel.establismentListdata[index];
                            return Card(
                              color: AppColors.orange,
                              child: ListTile(
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                    CircleAvatar(
                                    radius: 40, // Adjust size as needed
                                    backgroundColor: AppColors.black,
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(establishData.establishmentPicture),
                                    ),
                                  ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        '${establishData.establishmentName}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'SmoochSans',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description: ${establishData.establishmentDescription}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Status: ${establishData.establishmentStatus}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      onPressed: () {


                                        Navigator.pushNamed(context, AppRoutes.editEstablishment, arguments: {
                                          'establishmentName': establishData.establishmentName,
                                          'establishmentDescription': establishData.establishmentDescription,
                                          'establishmentStatus': establishData.establishmentStatus,
                                          'establishmentPicture': establishData.establishmentPicture,
                                          'establishmentId': establishData.id,
                                          'establishmentLat': establishData.establishmentLat,
                                          'establishmentLong': establishData.establishmentLong,
                                          'establishmentAddress': establishData.establishmentAddress,
                                          'establishmentPhoneNumber': establishData.establishmentPhoneNumber,
                                          'establishmentEmail': establishData.establishmentEmail,
                                          'establishmentType': establishData.establishmentType,
                                        });

                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      onPressed: () {
                                        viewModel.deleteEstablishment(establishData.id, context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addSherterClinic);
        },
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }


}