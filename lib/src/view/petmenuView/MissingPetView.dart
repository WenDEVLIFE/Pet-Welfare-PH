import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:pet_welfrare_ph/src/widgets/MissingPetCard.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/modal/ReactionModal.dart';

import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../utils/ReactionUtils.dart';
import '../../widgets/SearchTextField.dart';
import '../ViewImage.dart';

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
                child: viewModel.isSearching
                    ? const Center(child: CircularProgressIndicator()) 
                    : viewModel.filterMissingPost.isEmpty
                        ? Center(
                            child: Text( 
                              viewModel.searchPostController.text.isEmpty
                                  ? 'No missing pet posts available.'
                                  : 'No results for "${viewModel.searchPostController.text}"',
                            ),
                          )
                        : ListView.builder(
                            itemCount: viewModel.filterMissingPost.length,
                            itemBuilder: (context, index) {
                              final post = viewModel.filterMissingPost[index];
                              return MissingPetCard(
                                post: post,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
       floatingActionButton:SpeedDial(
        icon: Icons.add,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        activeBackgroundColor: AppColors.black,
        activeForegroundColor: AppColors.white,
        children: [
          if (postViewModel.role.toLowerCase()!='admin') ...[
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