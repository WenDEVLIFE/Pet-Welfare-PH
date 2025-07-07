import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/modal/SearchPetModal.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/PetAdoptionCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class PetAdoptionView extends StatefulWidget {
  const PetAdoptionView({Key? key}) : super(key: key);

  @override
  PetAdoptionViewState createState() => PetAdoptionViewState();
}

class PetAdoptionViewState extends State<PetAdoptionView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToPetAdoptPost();
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
                hintText: 'Search in Pet Adoption',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.searchPetAdoptPost(searchText);
                },
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    // Initial loading state
                    if (postViewModel.isInitialLoading) {
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
                    if (postViewModel.filterPetAdoptPost.isEmpty) {
                      if (postViewModel.searchPostController.text.isNotEmpty) {
                        return Center(
                          child: Text(
                            'No "${postViewModel.searchPostController.text}" pets for adoption found',
                          ),
                        );
                      }
                      return const Center(
                        child: Text("No pets for adoption found."),
                      );
                    }

                    // Data display
                    return ListView.builder(
                      itemCount: postViewModel.filterPetAdoptPost.length,
                      itemBuilder: (context, index) {
                        var post = postViewModel.filterPetAdoptPost[index];
                        return PetAdoptionCard(
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
          if (postViewModel.role.toLowerCase() != 'admin') ...[
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
            label: 'Reload the Pet Adoption Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToPetAdoptPost();
            },
          ),
        ],
      ),
    );
  }
}