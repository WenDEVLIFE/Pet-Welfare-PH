import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../utils/AppColors.dart';
import '../../widgets/PostCard.dart';
import '../../widgets/SearchTextField.dart';

class PawSomeView extends StatefulWidget {
  const PawSomeView({Key? key}) : super(key: key);

  @override
  PawSomeState createState() => PawSomeState();
}

class PawSomeState extends State<PawSomeView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToPawExperiencePost();
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
                hintText: 'Search in Paw-some Experience',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.searchPawSome(searchText);
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
                    if (postViewModel.filterPawExperiencePost.isEmpty) {
                      if (postViewModel
                          .searchPostController.text.isNotEmpty) {
                        return Center(
                          child: Text(
                            'No "${postViewModel.searchPostController.text}" paw-some experience posts found',
                          ),
                        );
                      }
                      return const Center(
                        child: Text("No paw-some experience posts found."),
                      );
                    }

                    // Data display
                    return ListView.builder(
                      itemCount: postViewModel.filterPawExperiencePost.length,
                      itemBuilder: (context, index) {
                        var post =
                            postViewModel.filterPawExperiencePost[index];
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
            label: 'Reload the Paw-some Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToPawExperiencePost();
            },
          ),
        ],
      ),
    );
  }
}