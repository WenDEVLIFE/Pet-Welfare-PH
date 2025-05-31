import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:pet_welfrare_ph/src/widgets/FoundPetCard.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/modal/ReactionModal.dart';

import '../../modal/SearchPetModal.dart';
import '../../utils/AppColors.dart';
import '../../utils/ReactionUtils.dart';
import '../../widgets/SearchTextField.dart';
import '../ViewImage.dart';

class FoundPetView extends StatefulWidget {
  const FoundPetView({Key? key}) : super(key: key);

  @override
  FoundPetState createState() => FoundPetState();
}

class FoundPetState extends State<FoundPetView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToFoundPost();
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context);

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
                  postViewModel.searchFoundPost(searchText);
                },
              ),
              Expanded(
                child: postViewModel.filterFoundPost.isEmpty
                    ? Center(child: Text('No ${postViewModel.searchPostController.text} found pet post found'))
                    : ListView.builder(
                  itemCount: postViewModel.filterFoundPost.length,
                  itemBuilder: (context, index) {
                    var post = postViewModel.filterFoundPost[index];
                    
                    return FoundPetCard(
                        post: post,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth
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