import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../utils/AppColors.dart';
import '../../widgets/PostCard.dart';
import '../../widgets/SearchTextField.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  CommunityState createState() => CommunityState();
}

class CommunityState extends State<CommunityView> {
  late PostViewModel postViewModel;

  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToCommunityPost();
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
                hintText: 'Search in Community Announcements',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.searchCommunityPost(searchText);
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
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
                  if (postViewModel.filterCommunityPost.isEmpty) {
                    if (postViewModel.searchPostController.text.isNotEmpty) {
                      return Center(
                        child: Text(
                          'No "${postViewModel.searchPostController.text}" community posts found',
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No community announcements found."),
                    );
                  }

                  // Data display
                  return ListView.builder(
                    itemCount: postViewModel.filterCommunityPost.length,
                    itemBuilder: (context, index) {
                      var post = postViewModel.filterCommunityPost[index];
                      return PostCard(
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
          if (postViewModel.role.toLowerCase() == 'admin') ...[
            //======= PRINT STATEMENT ADDED HERE =======//
                () {
              print('======================================');
              print('===== ROLE CHECK: USER IS ADMIN ======');
              print('======================================');
              return SpeedDialChild(
                label: 'Create Post',
                child: const Icon(Icons.create),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.createpost);
                },
              );
            }(),
            //=========================================//
          ],
          SpeedDialChild(
            label: 'Reload the Community Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToCommunityPost();
            },
          ),
        ],
      ),
    );
  }
}