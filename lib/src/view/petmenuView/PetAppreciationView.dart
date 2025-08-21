import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/PostCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

// This is where the PetAppreciateView is defined. It displays a list of pet appreciation posts and allows users to search for them.
class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({super.key});

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.initializeAllListeners();
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
                hintText: 'Search in Pet Appreciation',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.onSearchChanged('Pet Appreciation', searchText);
                },
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    // Initial loading state
                    if (postViewModel.isPetAppreciationLoading) {
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
                    if (postViewModel.petAppreciationPosts.isEmpty) {
                      if (postViewModel.searchPostController.text.isNotEmpty) {
                        return Center(
                          child: Text(
                            'No "${postViewModel.searchPostController.text}" pet appreciation posts found',
                          ),
                        );
                      }
                      return const Center(
                        child: Text("No pet appreciation posts found."),
                      );
                    }

                    // Data display
                    return ListView.builder(
                      itemCount: postViewModel.petAppreciationPosts.length,
                      itemBuilder: (context, index) {
                        var post = postViewModel.petAppreciationPosts[index];
                        return PostCard(
                          post: post,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        );
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
            label: 'Reload the Pet Appreciation Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToPost();
            },
          ),
        ],
      ),
    );
  }
}