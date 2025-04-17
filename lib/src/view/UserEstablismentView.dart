import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'package:pet_welfrare_ph/src/view_model/EstablishmentViewModel.dart';
import 'package:provider/provider.dart';

import '../widgets/SearchTextField.dart';
import 'editdirectory/EditBusinessView.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';

class UserEstablismentView extends StatefulWidget {
  const UserEstablismentView({Key? key}) : super(key: key);

  @override
  EstablismentState createState() => EstablismentState();
}

class EstablismentState extends State<UserEstablismentView> {
  late EstablishmentViewModel establishmentViewModel;

  @override
  void initState() {
    super.initState();
    establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
    establishmentViewModel.setInitialLocation();
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
          CustomSearchTextField(
            controller: establishmentViewModel.searchController,
            screenHeight: screenHeight,
            hintText: 'Search a subscription....',
            fontSize: 16,
            keyboardType: TextInputType.text,
            onChanged: (searchText) {
              establishmentViewModel.filterSubscriptions(searchText);
            },
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
                  return Consumer<EstablishmentViewModel>(
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