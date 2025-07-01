import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/PostViewModel.dart';
import '../widgets/CallForAidCard.dart';
import '../widgets/PostCard.dart';
import '../widgets/SearchTextField.dart';
import '../widgets/FoundPetCard.dart';
import '../widgets/MissingPetCard.dart';
import '../widgets/PetAdoptionCard.dart';
import '../widgets/PetCareInsightCard.dart';
import '../widgets/PetForRescueCard.dart';
import '../utils/AppColors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileView> {
  late PostViewModel postViewModel;

   @override
  void initState() {
     super.initState();
     postViewModel = Provider.of<PostViewModel>(context, listen: false);
     postViewModel.listenToMyPost();
   }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Post',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Column(
        children: [
          CustomSearchTextField(
            controller: postViewModel.searchPostController,
            screenHeight: screenHeight,
            hintText: 'Search in My Post',
            fontSize: 16,
            keyboardType: TextInputType.text,
            onChanged: postViewModel.searchMyPost,
          ),
          Expanded(
            child: postViewModel.filterMyPost.isEmpty
              ? _buildEmptyState(postViewModel)
              : ListView.builder(
              itemCount: postViewModel.filterMyPost.length,
              itemBuilder: (context, index) {
                final post = postViewModel.filterMyPost[index];
                final category = post.category;

                // Use a helper method to return  the appropriate widget
                return _buildPostCard(category, post, screenHeight, screenWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildEmptyState(PostViewModel postViewModel) {
  final bool isSearching = postViewModel.searchPostController.text.isNotEmpty;

  if (isSearching) {
    // Scenario 1: User searched, but no results were found
    return Center(
      child: Text(
        'No results found for "${postViewModel.searchPostController.text}"',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  } else {
    // Scenario 2: User has not searched, and their post list is empty
    return const Center(
      child: Text(
        "You haven't created any posts yet.",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}

  Widget _buildPostCard(String? category, dynamic post, double screenHeight, double screenWidth) {
    switch (category) {
      case 'Pet Appreciation':
      case 'Paw-some Experience':
      case 'Community Announcements':
      case 'Protect Our Pets: Report Abuse':
        return PostCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Found Pets':
        return FoundPetCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Missing Pets':
        return MissingPetCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Pet Adoption':
        return PetAdoptionCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Call for Aid':
        return CallForAidCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Pet For Rescue':
        return PetForRescueCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      case 'Pet Care Insights':
        return PetCareInsightCard(post: post, screenHeight: screenHeight, screenWidth: screenWidth);
      default:
        return const SizedBox.shrink(); // Return an empty widget if no match
    }
  }
}