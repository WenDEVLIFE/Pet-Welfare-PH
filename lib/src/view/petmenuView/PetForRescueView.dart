import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/PetForRescueCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class PetForRescueView extends StatefulWidget {
  const PetForRescueView({Key? key}) : super(key: key);

  @override
  PetForRescueViewState createState() => PetForRescueViewState();
}

class PetForRescueViewState extends State<PetForRescueView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.initializeAllListeners();
    postViewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
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
                    postViewModel.onSearchChanged('Pets For Rescue', searchText);
                  },
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      // Initial loading state
                      if (postViewModel.isPetForRescueLoading) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => PostCardSkeleton(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                        );
                      }

                      // Active searching state
                      if (postViewModel.isSearching) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => PostCardSkeleton(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                        );
                      }
                      
                      // Empty states
                      if (postViewModel.petForRescuePosts.isEmpty) {
                        if (postViewModel.searchPostController.text.isNotEmpty) {
                          return Center(
                            child: Text(
                              'No "${postViewModel.searchPostController.text}" pets for rescue found',
                            ),
                          );
                        }
                        return const Center(
                          child: Text("No pets for rescue found."),
                        );
                      }

                      // Data display
                      return ListView.builder(
                        itemCount: postViewModel.petForRescuePosts.length,
                        itemBuilder: (context, index) {
                          var post = postViewModel.petForRescuePosts[index];
                          return PetForRescueCard(
                              post: post,
                              screenHeight: screenHeight,
                              screenWidth: screenWidth);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          activeBackgroundColor: AppColors.black,
          activeForegroundColor: AppColors.white,
          children: [
            if (postViewModel.role != 'Admin') ...[
              SpeedDialChild(
                label: 'Create Post',
                child: const Icon(Icons.create),
                onTap: () {
                  postViewModel.navigatoToCreatePost(context);
                },
              ),
            ],
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
        ));
  }
}