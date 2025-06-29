import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../DialogView/ReportDialog.dart';
import '../modal/FormAdoptionModal.dart';
import '../modal/ReactionModal.dart';
import '../model/TagModel.dart';
import '../utils/AppColors.dart';
import '../utils/ReactionUtils.dart';
import '../utils/Route.dart';
import '../utils/ToastComponent.dart';
import '../view/ViewImage.dart';
import '../view/editdirectory/EditPostView.dart';
import '../view_model/ApplyAdoptionViewModel.dart';
import '../Animation/CardShimmerWidget.dart';
import 'CustomText.dart';
import 'ExpandableText.dart';
import 'ExpandedTags.dart';

class PetForRescueCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const PetForRescueCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);



  @override
  State<PetForRescueCard> createState() => PetForRescueCardState();

}

class PetForRescueCardState extends State<PetForRescueCard> {
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
              Expanded( // Use Expanded to take up remaining space
                child: Column(
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
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  final currentUserId = Provider.of<PostViewModel>(context, listen: false).currentUserId;
                  final isAdmin = postViewModel.role.toLowerCase() == 'admin' || postViewModel.role.toLowerCase() == "sub-admin";
                  final isPostOwner = widget.post.postOwnerId == currentUserId;

                  return [
                    if (isAdmin || isPostOwner)
                      PopupMenuItem(value: 'Edit', child: const Text('Edit'), onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPostView(
                              postId: widget.post.postId,
                              category: widget.post.category,
                            ),
                          ),
                        );
                      },),
                    if (isAdmin || isPostOwner)
                      PopupMenuItem(value: 'Delete', child: const Text('Delete'), onTap: (){
                        // Delete the image to the database
                        postViewModel.deletePost(widget.post.category,context, widget.post.postId);
                        ToastComponent().showMessage(Colors.green, 'Post Deleted Successfully');
                      },),
                    if (!isPostOwner)
                      PopupMenuItem(value: 'Message', child: const Text('Message'), onTap: (){
                        // Determine which ID is the other user (not current user)
                        final otherUserId = currentUserId == widget.post.postOwnerId
                            ? widget.post.postOwnerId
                            : widget.post.postOwnerId;

                        Navigator.pushNamed(context, AppRoutes.message, arguments: {
                          'receiverID': otherUserId
                        });
                      },),
                    PopupMenuItem(
                      value: 'Report',
                      child: const Text('Report'),
                      onTap: () {
                        Future.delayed(
                          Duration.zero,
                              () => showDialog(
                            context: context,
                            builder: (context) => ReportDialog(widget.post.postId),
                          ),
                        );
                      },
                    ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ExpandableText(
              text: post.postDescription,
            ),
          ),
          StreamBuilder<List<TagModel>>(
            stream: post.tagStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Handle errors
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox(); // Return an empty widget if no tags are available
              } else {
                final tags = snapshot.data!.map((tag) => tag.name).toList();
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ExpandableTags(tags: tags),
                );
              }
            },
          ),
          StreamBuilder<List<String>>(
            stream: post.imageStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show a loading indicator
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('')); // Handle empty stream
              } else {
                final imageUrls = snapshot.data!;
                return SizedBox(
                  height: screenHeight * 0.3,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, imageIndex) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewImage(),
                              settings: RouteSettings(
                                arguments: {
                                  'imageUrls': imageUrls,
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
                            imageUrl: imageUrls[imageIndex],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          ExpansionTile(
            title: CustomText(
              text: 'Pet Rescue Details',
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
                      text: 'Pet Type:',
                      size: 20,
                      color: AppColors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    CustomText(
                      text: '${post.rescuePetType}',
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
                      text: post.rescueBreed,
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
                      text: '${post.rescuePetGender}',
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
                      text: '${post.rescuePetColor}',
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
                      text: '${post.rescuePetSize}',
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
                      text: '${post.rescueAddress}',
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
                      text: '${post.rescueStatus}',
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
                          ApplyAdoptionViewModel applyAdoptionViewModel = Provider.of<ApplyAdoptionViewModel>(context, listen: false);
                          applyAdoptionViewModel.showReminders(context);
                          return FormAdoptionModal(post.postId);
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}