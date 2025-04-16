import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

import '../DialogView/ReportDialog.dart';
import '../modal/ReactionModal.dart';
import '../utils/AppColors.dart';
import '../utils/ReactionUtils.dart';
import '../view/ViewImage.dart';
import 'CardShimmerWidget.dart';
import 'CustomText.dart';

class PetCareInsightCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const PetCareInsightCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<PetCareInsightCard> createState() => _PetCareInsightCardState();

}

class _PetCareInsightCardState extends State<PetCareInsightCard> {
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
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              // Handle menu item selection
                              print('Selected: $value');
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: const Text('Edit'),
                                  onTap: () {
                                    // Handle edit action
                                  },
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: const Text('Delete'),
                                  onTap: () {
                                    // Handle edit action
                                  },
                                ),

                                PopupMenuItem<String>(
                                  value: 'Report',
                                  child: const Text('Report'),
                                  onTap: () {
                                    // Handle edit action
                                    showDialog(context: context, builder: (context) {
                                      return ReportDialog(post.postId);
                                    });
                                  },
                                ),
                              ];
                            },
                            icon: const Icon(Icons.more_vert), // Three dots icon
                          ),
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
                      if (post.tags.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Tags',
                            style: TextStyle(
                              fontFamily: 'SmoochSans',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: post.tags.map((tag) {
                              return Chip(
                                label: Text(tag.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrls[imageIndex],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      ExpansionTile(
                        title: CustomText(
                          text: 'Pet Care Insight Details',
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
                                  text: 'Clinic / Establisment Name:',
                                  size: 20,
                                  color: AppColors.black,
                                  weight: FontWeight.w700,
                                  align: TextAlign.left,
                                  screenHeight: screenHeight,
                                  alignment: Alignment.centerLeft,
                                ),
                                CustomText(
                                  text: '${post.establisHment_Clinic_Name}',
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
                                  text: '${post.establismentAdddress}',
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
                                  text: '${post.establismentRegion}, ${post.establismentProvinces}, ${post.establismentCity}, ${post.establismentBarangay}',
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
                              Text('$reactionCount likes'),
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
                              Text('$commentCount comments'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );

  }
}