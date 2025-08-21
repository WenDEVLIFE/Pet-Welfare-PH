import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CallForAidCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class CallOfAidView extends StatefulWidget {
  const CallOfAidView({Key? key}) : super(key: key);

  @override
  CallOfAidViewState createState() => CallOfAidViewState();
}

// This is where the CallOfAidView is defined, which displays posts related to calls for aid.
class CallOfAidViewState extends State<CallOfAidView> {
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
                hintText: 'Search in Call For Aid post',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.onSearchChanged('Call for Aid', searchText);
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
                  // Initial loading state
                  if (postViewModel.isCallForAidLoading) {
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
                  if (postViewModel.callForAidPosts.isEmpty) {
                    if (postViewModel.searchPostController.text.isNotEmpty) {
                      return Center(
                        child: Text(
                          'No "${postViewModel.searchPostController.text}" call for aid posts found',
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No call for aid posts found."),
                    );
                  }

                  // Data display
                  return ListView.builder(
                    itemCount: postViewModel.callForAidPosts.length,
                    itemBuilder: (context, index) {
                      var post = postViewModel.callForAidPosts[index];
                      return CallForAidCard(
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
            label: 'Reload the Call for Aid Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToCallforAidPost();
            },
          ),
        ],
      ),
    );
  }
}