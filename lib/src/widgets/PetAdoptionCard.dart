import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../modal/FormAdoptionModal.dart';
import '../modal/ReactionModal.dart';
import '../utils/AppColors.dart';
import '../utils/ReactionUtils.dart';
import '../view/ViewImage.dart';
import '../view_model/ApplyAdoptionViewModel.dart';
import 'CardShimmerWidget.dart';
import 'CustomText.dart';

class PetAdoptionCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;


  const PetAdoptionCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<PetAdoptionCard> createState() => _PetAdoptionCardState();

}

class _PetAdoptionCardState extends State<PetAdoptionCard> {
  late PostModel post;
  late double screenHeight;
  late double screenWidth;
  String? userReaction;
  int reactionCount = 0;
  int commentCount = 0;
  bool isLoading = true;
  bool hasReacted = false;
  late PostViewModel postViewModel;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    screenHeight = widget.screenHeight;
    screenWidth = widget.screenWidth;
    _loadData();
  }
  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        postViewModel.getUserReaction(widget.post.postId),
        postViewModel.getReactionCount(widget.post.postId),
        postViewModel.getCommentCount(widget.post.postId),
      ]);

      setState(() {
        userReaction = results[0] as String?;
        reactionCount = (results[1] as int?)!;
        commentCount = (results[2] as int?)!;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading post data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleReaction() async {
    if (userReaction != null) {
      await postViewModel.removeReaction(widget.post.postId);
      setState(() {
        userReaction = null;
        reactionCount -= 1;
      });
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ReactionModal(
            onReactionSelected: (reaction) async {
              await postViewModel.addReaction(widget.post.postId, reaction);
              setState(() {
                userReaction = reaction;
                reactionCount += 1;
              });
              Navigator.pop(context); // Close the modal after selecting
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = postViewModel.formatTimestamp(widget.post.timestamp);

    if (isLoading) {
      return PostCardSkeleton(
        screenHeight: widget.screenHeight,
        screenWidth: widget.screenWidth,
      );
    }
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: screenHeight * 0.03,
                  backgroundImage: CachedNetworkImageProvider(post.profileUrl),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      post.postOwnerName,
                      style: const TextStyle(
                        fontFamily: 'SmoochSans',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontFamily: 'SmoochSans',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              post.postDescription,
              style: const TextStyle(
                fontFamily: 'SmoochSans',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.3,
            child: PageView.builder(
              itemCount: post.imageUrls.length,
              itemBuilder: (context, imageIndex) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewImage(),
                        settings: RouteSettings(
                          arguments: {
                            'imageUrls': post.imageUrls,
                            'initialIndex': imageIndex,
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrls[imageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          ExpansionTile(
            title: CustomText(
              text: 'Pet Adoption Details',
              size: 24,
              color: AppColors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CustomText(
                      text: 'Pet Name:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petNameAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Type:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petTypeAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Breed:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: post.petBreedAdopt,
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Gender',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petGenderAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Age',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petAgeAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Color:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petColorAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Pet Size:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petSizeAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Address:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.petAddressAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Region/Province/City/Barangay:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: post.regProCiBagAdopt,
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: 'Status',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.StatusAdopt}',
                      size: 16,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      userReaction != null
                          ? ReactionUtils.getReactionIcon(userReaction!)
                          : Icons.thumb_up_outlined,
                      color: userReaction != null
                          ? ReactionUtils.getReactionColor(userReaction!)
                          : null,
                    ),
                    onPressed: _handleReaction,
                  ),
                  Text('$reactionCount likes', style: const TextStyle(
                    fontFamily: 'SmoochSans',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      postViewModel.showComments(context, post.postId);
                    },
                  ),
                  Text('$commentCount comments', style: const TextStyle(
                    fontFamily: 'SmoochSans',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.pets),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          ApplyAdoptionViewModel applyAdoptionViewModel = Provider
                              .of<ApplyAdoptionViewModel>(context,
                              listen: false);
                          applyAdoptionViewModel.showReminders(context);
                          return FormAdoptionModal(post.postId);
                        },
                      );
                    },
                  ),
                  const Text('Adopt Me', style: TextStyle(
                    fontFamily: 'SmoochSans',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}