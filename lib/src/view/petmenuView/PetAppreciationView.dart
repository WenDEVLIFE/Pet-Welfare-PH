import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/widgets/PostCard.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';

class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({Key? key}) : super(key: key);

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToPost();
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
                  postViewModel.searchPost(searchText);
                },
              ),
          Expanded(
          child: postViewModel.filteredPost.isEmpty
          ? Center(child: Text('No ${postViewModel.searchPostController.text} pet appreciation post found'))
              : ListView.builder(
          itemCount: postViewModel.filteredPost.length,
          itemBuilder: (context, index) {
          var post = postViewModel.filteredPost[index];
          return PostCard(
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
            label: 'Reload the Pet Appreciation Posts',
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