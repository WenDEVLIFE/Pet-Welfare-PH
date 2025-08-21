import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../DialogView/ReportDialog.dart';
import '../modal/PetStatusModal.dart';
import '../modal/ReactionModal.dart';
import '../model/PostModel.dart';
import '../model/TagModel.dart';
import '../utils/AppColors.dart';
import '../utils/ReactionUtils.dart';
import '../utils/Route.dart';
import '../view/ViewImage.dart';
import '../view/editdirectory/EditPostView.dart';
import '../view_model/PostViewModel.dart';
import '../Animation/CardShimmerWidget.dart';
import 'CustomText.dart';
import 'ExpandableText.dart';
import 'ExpandedTags.dart';

class MissingPetCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const MissingPetCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<MissingPetCard> createState() => _MissingPetCardState();
}

class _MissingPetCardState extends State<MissingPetCard>
    with AutomaticKeepAliveClientMixin {
  late PostModel post;
  late double screenHeight;
  late double screenWidth;
  String? userReaction;
  int reactionCount = 0;
  int commentCount = 0;
  bool isLoading = true;
  late PostViewModel postViewModel;

  final PageController _pageController = PageController(keepPage: true);

  @override
  bool get wantKeepAlive => true; // keep state across rebuilds

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

      if (mounted) {
        setState(() {
          userReaction = results[0] as String?;
          reactionCount = (results[1] as int?)!;
          commentCount = (results[2] as int?)!;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> handleReaction() async {
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
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required when using AutomaticKeepAliveClientMixin
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
          /// Header Row
          _buildHeader(formattedDate, context),

          /// Post description
          Padding(
            padding: const EdgeInsets.all(10),
            child: ExpandableText(text: post.postDescription),
          ),

          /// Tags (kept stable with shrinkWrap + never scrollable)
          StreamBuilder<List<TagModel>>(
            stream: post.tagStream,
            builder: (context, snapshot) {
              final tags = snapshot.data?.map((e) => e.name).toList() ?? [];
              if (tags.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ExpandableTags(tags: tags),
              );
            },
          ),

          /// Images with PageController(keepPage: true)
          StreamBuilder<List<String>>(
            stream: post.imageStream,
            builder: (context, snapshot) {
              final images = snapshot.data ?? [];
              if (images.isEmpty) return const SizedBox();

              return SizedBox(
                height: screenHeight * 0.3,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewImage(),
                            settings: RouteSettings(
                              arguments: {
                                'imageUrls': images,
                                'initialIndex': index,
                              },
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          /// Pet Details (ExpansionTile keeps state)
          _buildPetDetails(),

          /// Reaction & Comments Row
          _buildReactionsRow(context),
        ],
      ),
    );
  }

  Widget _buildHeader(String formattedDate, BuildContext context) {
    return Row(
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
            Text(post.postOwnerName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(formattedDate,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          // 1. Logic is centralized here for better readability and management.
          onSelected: (String value) {
            final postViewModel =
                Provider.of<PostViewModel>(context, listen: false);

            // 2. This delay ensures the menu is closed before navigating or showing a dialog, preventing errors.
            Future.delayed(Duration.zero, () {
              switch (value) {
                case 'Edit':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostView(
                        postId: widget.post.postId,
                        category: widget.post.category,
                      ),
                    ),
                  );
                  break;

                case 'Update Status':
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
                    },
                  );
                  break;

                case 'Delete':
                  postViewModel.deletePost(
                      widget.post.category, context, widget.post.postId);
                  break;

                case 'Message':
                  // The check for '!isPostOwner' in itemBuilder already ensures this is safe.
                  final otherUserId = widget.post.postOwnerId;
                  Navigator.pushNamed(context, AppRoutes.message, arguments: {
                    'receiverID': otherUserId,
                  });
                  break;

                case 'Report':
                  showDialog(
                    context: context,
                    builder: (context) => ReportDialog(widget.post.postId),
                  );
                  break;
              }
            });
          },
          itemBuilder: (BuildContext context) {
            final postViewModel =
                Provider.of<PostViewModel>(context, listen: false);
            final currentUserId = postViewModel.currentUserId;
            // Assuming 'role' is accessible from postViewModel
            final isAdmin = postViewModel.role.toLowerCase() == 'admin';
            final isPostOwner = widget.post.postOwnerId == currentUserId;

            // 3. Each item now has a unique 'value' and no 'onTap' handler.
            return [
              if (isAdmin || isPostOwner)
                const PopupMenuItem(value: 'Edit', child: Text('Edit')),

              // You can decide who sees this option. Here, I assume only the owner/admin.
              if (isAdmin || isPostOwner)
                const PopupMenuItem(
                    value: 'Update Status', child: Text('Update Status')),

              if (isAdmin || isPostOwner)
                const PopupMenuItem(value: 'Delete', child: Text('Delete')),

              if (!isPostOwner)
                const PopupMenuItem(value: 'Message', child: Text('Message')),

              const PopupMenuItem(value: 'Report', child: Text('Report')),
            ];
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildPetDetails() {
    return ExpansionTile(
      iconColor: AppColors.black,
      collapsedIconColor: AppColors.black,
      textColor: AppColors.black,
      leading: const Icon(FontAwesomeIcons.paw),
      title: CustomText(
        text: 'Missing Pet Details',
        size: 20,
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
              _petDetail("Pet Name:", post.petName),
              _petDetail("Pet Type:", post.petType),
              _petDetail("Pet Breed:", post.petBreed),
              _petDetail("Pet Gender:", post.petGender),
              _petDetail("Pet Age:", post.petAge),
              _petDetail("Pet Color:", post.petColor),
              if (post.petType == 'Others (for birds, reptiles, etc.)')
                _petDetail("Pet Collar:", post.petCollar),
              _petDetail("Pet Size:", post.petSize),
              _petDetail("Address:", post.petAddress),
              _petDetail("Region:", post.regProCiBag),
              _petDetail("Status:", post.Status),
            ],
          ),
        ),
      ],
    );
  }

  Widget _petDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          size: 18,
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
          weight: FontWeight.w400,
          align: TextAlign.left,
          screenHeight: screenHeight,
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildReactionsRow(BuildContext context) {
    return Row(
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
          onPressed: handleReaction,
        ),
        Text('$reactionCount likes'),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {
            postViewModel.showComments(context, post.postId);
          },
        ),
        Text('$commentCount comments'),
      ],
    );
  }
}
