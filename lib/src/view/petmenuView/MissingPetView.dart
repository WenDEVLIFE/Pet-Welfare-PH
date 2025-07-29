import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/MissingPetCard.dart';
import 'package:provider/provider.dart';

import '../../Animation/CardShimmerWidget.dart';
import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class MissingPetView extends StatefulWidget {
  const MissingPetView({Key? key}) : super(key: key);

  @override
  MissingPetState createState() => MissingPetState();
}

class MissingPetState extends State<MissingPetView> {
  late PostViewModel postViewModel;

  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (postViewModel.searchPostController.text.isNotEmpty) {
        postViewModel.searchPostController.clear();
      }
      postViewModel.listenToMissingPost();
    });
    postViewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomSearchTextField(
                controller: viewModel.searchPostController,
                screenHeight: screenHeight,
                hintText: 'Search in Missing Pets',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  viewModel.searchMissingPost(searchText);
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
                  // Initial loading state
                  if (viewModel.isInitialLoading) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => PostCardSkeleton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                    );
                  }

                  // Active searching state
                  if (viewModel.isSearching) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => PostCardSkeleton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                    );
                  }

                  // Empty states
                  if (viewModel.filterMissingPost.isEmpty) {
                    if (viewModel.searchPostController.text.isNotEmpty) {
                      return Center(
                        child: Text(
                          'No results for "${viewModel.searchPostController.text}"',
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No missing pet posts found."),
                    );
                  }

                  // Data display
                  return ListView.builder(
                    itemCount: viewModel.filterMissingPost.length,
                    itemBuilder: (context, index) {
                      final post = viewModel.filterMissingPost[index];
                      return MissingPetCard(
                        post: post,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      );
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
            label: 'Reload the Missing Pet Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToMissingPost();
            },
          ),
        ],
      ),
    );
  }
}