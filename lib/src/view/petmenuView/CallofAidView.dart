import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/view/ViewImage.dart';
import 'package:pet_welfrare_ph/src/widgets/CallForAidCard.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/modal/ReactionModal.dart';

import '../../modal/DonateModal.dart';
import '../../modal/FormAdoptionModal.dart';
import '../../utils/AppColors.dart';
import '../../utils/ReactionUtils.dart';
import '../../view_model/ApplyAdoptionViewModel.dart';
import '../../widgets/SearchTextField.dart';

class CallOfAidView extends StatefulWidget {
  const CallOfAidView({Key? key}) : super(key: key);

  @override
  AidState createState() => AidState();
}

class AidState extends State<CallOfAidView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToCallforAidPost();
  }
  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);

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
                  postViewModel.searchCallforAidPost(searchText);
                },
              ),
              Expanded(
                child: postViewModel.filterCallforAidPost.isEmpty
                    ? Center(child: Text('No ${postViewModel.searchPostController.text} call of aid post found'))
                    : ListView.builder(
                  itemCount: postViewModel.filterCallforAidPost.length,
                  itemBuilder: (context, index) {
                    var post = postViewModel.filterCallforAidPost[index];
                    return CallForAidCard(
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
      floatingActionButton:  SpeedDial(
        icon: Icons.add,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        activeBackgroundColor: AppColors.black,
        activeForegroundColor: AppColors.white,
        children: [
          SpeedDialChild(
            label: 'Create Post',
            child: const Icon(Icons.create),
            onTap: () {
             postViewModel.navigatoToCreatePost(context);
            },
          ),
          SpeedDialChild(
            label: 'Reload the Call for Aid Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToCallforAidPost();
            },
          ),
        ],
      )
    );
  }
}