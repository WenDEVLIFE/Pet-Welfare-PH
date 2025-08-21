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

// This is where the CommunityView is defined, which displays community announcements and allows users to create posts if they are admins.
class CommunityState extends State<CommunityView> {
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
                hintText: 'Search in Community Announcements',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.onSearchChanged('Community Announcements', searchText);
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
                  // Initial loading state
                  if (postViewModel.isCommunityAnnouncementsLoading) {
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
                  if (postViewModel.communityAnnouncementsPosts.isEmpty) {
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
                    itemCount: postViewModel.communityAnnouncementsPosts.length,
                    itemBuilder: (context, index) {
                      var post = postViewModel.communityAnnouncementsPosts[index];
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