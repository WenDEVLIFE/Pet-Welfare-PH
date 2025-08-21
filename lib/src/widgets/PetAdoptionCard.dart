import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/modal/PetStatusModal.dart';
import 'package:pet_welfrare_ph/src/modal/ViewAdoptionModal.dart';
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
import '../view/ViewImage.dart';
import '../view/editdirectory/EditPostView.dart';
import '../view_model/ApplyAdoptionViewModel.dart';
import '../Animation/CardShimmerWidget.dart';
import 'CustomText.dart';
import 'ExpandableText.dart';
import 'ExpandedTags.dart';

class PetAdoptionCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const PetAdoptionCard({
    super.key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<PetAdoptionCard> createState() => _PetAdoptionCardState();
}

class _PetAdoptionCardState extends State<PetAdoptionCard>
    with AutomaticKeepAliveClientMixin {
  late double screenHeight;
  late double screenWidth;
  String? userReaction;
  int reactionCount = 0;
  int commentCount = 0;
  bool isLoading = true;
  late PostViewModel postViewModel;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    screenHeight = widget.screenHeight;
    screenWidth = widget.screenWidth;
    _pageController = PageController(keepPage: true);
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      final results = await Future.wait([
        postViewModel.getUserReaction(widget.post.postId),
        postViewModel.getReactionCount(widget.post.postId),
        postViewModel.getCommentCount(widget.post.postId),
      ]);

      if (mounted) {
        setState(() {
          userReaction = results[0] as String?;
          reactionCount = (results[1] as int?) ?? 0;
          commentCount = (results[2] as int?) ?? 0;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading post data: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleReaction() async {
    if (userReaction != null) {
      await postViewModel.removeReaction(widget.post.postId);
      if (mounted) {
        setState(() {
          userReaction = null;
          reactionCount -= 1;
        });
      }
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ReactionModal(
            onReactionSelected: (reaction) async {
              await postViewModel.addReaction(widget.post.postId, reaction);
              if (mounted) {
                setState(() {
                  userReaction = reaction;
                  reactionCount += 1;
                });
              }
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: screenHeight * 0.03,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.post.profileUrl),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.post.postOwnerName,
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
                        postViewModel.formatTimestamp(widget.post.timestamp),
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
                  final currentUserId =
                      Provider.of<PostViewModel>(context, listen: false)
                          .currentUserId;
                  final isAdmin = postViewModel.role.toLowerCase() == 'admin' ||
                      postViewModel.role.toLowerCase() == "sub-admin";
                  final isPostOwner = widget.post.postOwnerId == currentUserId;

                  return [
                    if (isAdmin || isPostOwner)
                      PopupMenuItem(
                        value: 'Edit',
                        child: const Text('Edit'),
                        onTap: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPostView(
                                postId: widget.post.postId,
                                category: widget.post.category,
                              ),
                            ),
                          );
                        }),
                      ),
                    if (isAdmin || isPostOwner)
                      PopupMenuItem(
                        child: const Text('View Submitted Adoptions'),
                        onTap: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return ViewAdoptionModal(
                                    postId: widget.post.postId);
                              });
                        }),
                      ),
                    PopupMenuItem(
                      child: const Text('Update Status'),
                      onTap: () =>
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return PetStatusModal(
                                onStatusUpdated: () {
                                  setState(() {});
                                },
                                postId: widget.post.postId,
                                category: widget.post.category,
                              );
                            });
                      }),
                    ),
                    if (isAdmin || isPostOwner)
                      PopupMenuItem(
                        value: 'Delete',
                        child: const Text('Delete'),
                        onTap: () {
                          postViewModel.deletePost(widget.post.category,
                              context, widget.post.postId);
                        },
                      ),
                    if (!isPostOwner)
                      PopupMenuItem(
                        value: 'Message',
                        child: const Text('Message'),
                        onTap: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                          final otherUserId = widget.post.postOwnerId;
                          Navigator.pushNamed(context, AppRoutes.message,
                              arguments: {'receiverID': otherUserId});
                        }),
                      ),
                    PopupMenuItem(
                        value: 'Report',
                        child: const Text('Report'),
                        onTap: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ReportDialog(widget.post.postId),
                              );
                            })),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(10),
            child: ExpandableText(
              text: widget.post.postDescription,
            ),
          ),

          // Tags Section
          StreamBuilder<List<TagModel>>(
            stream: widget.post.tagStream,
            builder: (context, snapshot) {
              final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
              final isWaiting =
                  snapshot.connectionState == ConnectionState.waiting;

              if (!hasData && !isWaiting) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.all(10.0),
                constraints: const BoxConstraints(minHeight: 50),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ExpandableTags(
                      tags: hasData
                          ? snapshot.data!.map((tag) => tag.name).toList()
                          : [],
                    ),
                    if (isWaiting) const CupertinoActivityIndicator(),
                  ],
                ),
              );
            },
          ),

          // Image Section
          StreamBuilder<List<String>>(
            stream: widget.post.imageStream,
            builder: (context, snapshot) {
              final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
              final isWaiting =
                  snapshot.connectionState == ConnectionState.waiting;

              if (!hasData && !isWaiting) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: screenHeight * 0.3,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: hasData,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: hasData ? snapshot.data!.length : 0,
                        itemBuilder: (context, imageIndex) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewImage(),
                                  settings: RouteSettings(
                                    arguments: {
                                      'imageUrls': snapshot.data!,
                                      'initialIndex': imageIndex,
                                    },
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data![imageIndex],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                    if (isWaiting) const CupertinoActivityIndicator(),
                  ],
                ),
              );
            },
          ),

          // Details Expansion Tile
          ExpansionTile(
            iconColor: AppColors.black,
            collapsedIconColor: AppColors.black,
            textColor: AppColors.black,
            leading: const Icon(Icons.pets),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Pet Name:", widget.post.petNameAdopt),
                    _buildDetailRow("Pet Type:", widget.post.petTypeAdopt),
                    _buildDetailRow("Pet Breed:", widget.post.petBreedAdopt),
                    _buildDetailRow("Pet Gender:", widget.post.petGenderAdopt),
                    _buildDetailRow("Pet Age:", widget.post.petAgeAdopt),
                    _buildDetailRow("Pet Color:", widget.post.petColorAdopt),
                    _buildDetailRow("Pet Size:", widget.post.petSizeAdopt),
                    _buildDetailRow("Address:", widget.post.petAddressAdopt),
                    _buildDetailRow(
                      "Location:",
                      '${widget.post.petRegionAdopt}, ${widget.post.petProvinceAdopt}, ${widget.post.petCityAdopt}, ${widget.post.petBarangayAdopt}',
                    ),
                    _buildDetailRow("Status:", widget.post.StatusAdopt),
                  ],
                ),
              ),
            ],
          ),

          // Action Row
          SizedBox(
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: !isLoading,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              userReaction != null
                                  ? ReactionUtils.getReactionIcon(userReaction!)
                                  : Icons.thumb_up_outlined,
                              color: userReaction != null
                                  ? ReactionUtils.getReactionColor(
                                      userReaction!)
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
                              postViewModel.showComments(
                                  context, widget.post.postId);
                            },
                          ),
                          Text('$commentCount comments'),
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
                                  return FormAdoptionModal(widget.post.postId);
                                },
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text('Adopt Me'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isLoading) const CupertinoActivityIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: title,
            size: 20,
            color: AppColors.black,
            weight: FontWeight.w700,
            align: TextAlign.left,
            screenHeight: screenHeight,
            alignment: Alignment.centerLeft,
          ),
          CustomText(
            text: value,
            size: 16,
            color: AppColors.black,
            weight: FontWeight.normal,
            align: TextAlign.left,
            screenHeight: screenHeight,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }
}
