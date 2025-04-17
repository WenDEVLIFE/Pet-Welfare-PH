import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/widgets/PetForRescueCard.dart';
import 'package:pet_welfrare_ph/src/widgets/ProtectPetCard.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';


class PetForRescueView extends StatefulWidget {
  const PetForRescueView({Key? key}) : super(key: key);

  @override
  ProtectPetState createState() => ProtectPetState();
}

class ProtectPetState extends State<PetForRescueView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Consumer<PostViewModel>(
          builder: (context, postViewModel, child) {
            return Column(
              children: [
                CustomSearchTextField(
                  controller: postViewModel.searchPostController,
                  screenHeight: screenHeight,
                  hintText: 'Search in Pet For Rescue',
                  fontSize: 16,
                  keyboardType: TextInputType.text,
                  onChanged: (searchText) {
                    postViewModel.searchPetForRescue(searchText);
                  },
                ),
                Expanded(
                  child: postViewModel.filterPetForRescuePost.isEmpty
                      ? Center(child: Text('No ${postViewModel.searchPostController.text} pets for rescue found'))
                      : ListView.builder(
                    itemCount: postViewModel.filterPetForRescuePost.length,
                    itemBuilder: (context, index) {
                      var post = postViewModel.filterPetForRescuePost[index];

                      return PetForRescueCard(
                          post: post,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton:  SpeedDial(
          icon: Icons.add,
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          activeBackgroundColor: AppColors.black,
          activeForegroundColor: AppColors.white,
          children: [
            SpeedDialChild(
              label: 'Create Post',
              child: const Icon(Icons.create),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.createpost);
              },
            ),
            SpeedDialChild(
              label: 'Advanced Search',
              child: const Icon(Icons.search),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const SearchPetModal();
                  },
                );
              },
            ),
            SpeedDialChild(
              label: 'Reload the Pets For Rescue Posts',
              child: const Icon(Icons.refresh),
              onTap: () {
                postViewModel.listenToPetForRescuePost();
              },
            ),
          ],
        )
    );
  }
}