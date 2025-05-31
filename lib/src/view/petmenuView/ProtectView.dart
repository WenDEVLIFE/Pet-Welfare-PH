import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/widgets/ProtectPetCard.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import '../../utils/AppColors.dart';
import '../../widgets/SearchTextField.dart';


class ProtectPetView extends StatefulWidget {
  const ProtectPetView({Key? key}) : super(key: key);

  @override
  ProtectPetState createState() => ProtectPetState();
}

class ProtectPetState extends State<ProtectPetView> {
  late PostViewModel postViewModel;
  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.listenToProtectedPost();
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
                hintText: 'Search in Protect Our Pets:Report Abuse',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.searchProtectedPost(searchText);
                },
              ),
          Expanded(
          child: postViewModel.filterProtectedPost.isEmpty
          ? Center(child: Text('No ${postViewModel.searchPostController.text} cases found'))
              : ListView.builder(
          itemCount: postViewModel.filterProtectedPost.length,
          itemBuilder: (context, index) {
          var post = postViewModel.filterProtectedPost[index];

          return ProtectPetCard(post: post,
              screenHeight: screenHeight
              , screenWidth: screenWidth
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
            label: 'Reload the Protect Pets Posts',
            child: const Icon(Icons.refresh),
            onTap: () {
              postViewModel.listenToProtectedPost();
            },
          ),
        ],
      )
    );
  }
}