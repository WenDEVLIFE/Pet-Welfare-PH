import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/FoundPetCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class FoundPetView extends StatefulWidget {
  const FoundPetView({Key? key}) : super(key: key);

  @override
  FoundPetState createState() => FoundPetState();
}

// This is where the FoundPetView is defined, which displays found pet posts.
class FoundPetState extends State<FoundPetView> {
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
    PostViewModel postViewModel =
        Provider.of<PostViewModel>(context, listen: false);

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
                hintText: 'Search in Found Pets',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.onSearchChanged('Found Pets', searchText);
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
                  // Initial loading state
                  if (postViewModel.isPetFoundsLoading) {
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
                  if (postViewModel.petFoundsPosts.isEmpty) {
                    if (postViewModel.searchPostController.text.isNotEmpty) {
                      return Center(
                        child: Text(
                          'No "${postViewModel.searchPostController.text}" found pet posts found',
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No found pet posts found."),
                    );
                  }

                  // Data display
                  return ListView.builder(
                    itemCount: postViewModel.petFoundsPosts.length,
                    itemBuilder: (context, index) {
                      var post = postViewModel.petFoundsPosts[index];

                      return FoundPetCard(
                          post: post,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth);
                    },
                  );
                }),
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
            label: 'Reload the Found Pets Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToFoundPost();
            },
          ),
        ],
      ),
    );
  }
}