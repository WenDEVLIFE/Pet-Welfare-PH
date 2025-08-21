import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view/editdirectory/EditPostView.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../DialogView/ReportDialog.dart';
import '../modal/ReactionModal.dart';
import '../model/TagModel.dart';
import '../utils/ReactionUtils.dart';
import '../utils/Route.dart';
import '../view/ViewImage.dart';
import '../Animation/CardShimmerWidget.dart';
import 'ExpandableText.dart';
import 'ExpandedTags.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final double screenHeight;
  final double screenWidth;

  const PostCard({
    Key? key,
    required this.post,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin<PostCard> {
  String? userReaction;
  int reactionCount = 0;
  int commentCount = 0;
  bool isMetaLoading = true; // renamed for clarity
  late PostViewModel postViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    postViewModel = Provider.of<PostViewModel>(context, listen: false);
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final results = await Future.wait([
        postViewModel.getUserReaction(widget.post.postId),
        postViewModel.getReactionCount(widget.post.postId),
        postViewModel.getCommentCount(widget.post.postId),
      ]);

      if (!mounted) return;
      setState(() {
        userReaction = results[0] as String?;
        reactionCount = (results[1] as int?) ?? 0;
        commentCount = (results[2] as int?) ?? 0;
        isMetaLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isMetaLoading = false);
    }
  }

  Future<void> _handleReaction() async {
    if (userReaction != null) {
      await postViewModel.removeReaction(widget.post.postId);
      if (!mounted) return;
      setState(() {
        userReaction = null;
        reactionCount = (reactionCount - 1).clamp(0, 1 << 31);
      });
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ReactionModal(
            onReactionSelected: (reaction) async {
              await postViewModel.addReaction(widget.post.postId, reaction);
              if (!mounted) return;
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

  Widget _skeletonBox({double width = 64, double height = 16}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // IMPORTANT for keep-alive
    final formattedDate = postViewModel.formatTimestamp(widget.post.timestamp);
    final screenHeight = widget.screenHeight;
    final screenWidth = widget.screenWidth;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: widget.screenHeight * 0.03,
                  backgroundImage:
                  CachedNetworkImageProvider(widget.post.profileUrl),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    widget.post.postOwnerName,
                    style: const TextStyle(
                      fontFamily: 'SmoochSans',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontFamily: 'SmoochSans',
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  final postViewModel =
                  Provider.of<PostViewModel>(context, listen: false);
                  final currentUserId = postViewModel.currentUserId;
                  final role = postViewModel.role;
                  final isAdmin = role.toLowerCase() == 'admin' ||
                      role.toLowerCase() == 'sub-admin';
                  final isPostOwner = widget.post.postOwnerId == currentUserId;

                  // Show toast or navigate safely after the popup menu closes
                  Future.delayed(Duration.zero, () async {
                    if ((isAdmin || isPostOwner) && value == 'Edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditPostView(
                                postId: widget.post.postId,
                                category: widget.post.category,
                              ),
                        ),
                      );
                    } else if ((isAdmin || isPostOwner) && value == 'Delete') {
                      postViewModel.deletePost(
                          widget.post.category, context, widget.post.postId);
                      ToastComponent().showMessage(
                          Colors.green, 'Post Deleted Successfully');
                    } else if (value == 'Message') {
                      final otherUserId = widget.post.postOwnerId;
                      Navigator.pushNamed(context, AppRoutes.message,
                          arguments: {
                            'receiverID': otherUserId,
                          });
                    } else if (value == 'Report') {
                      showDialog(
                        context: context,
                        builder: (context) => ReportDialog(widget.post.postId),
                      );
                    }
                  });
                },
                itemBuilder: (context) {
                  final postViewModel =
                  Provider.of<PostViewModel>(context, listen: false);
                  final currentUserId = postViewModel.currentUserId;
                  final isAdmin = postViewModel.role.toLowerCase() == 'admin' ||
                      postViewModel.role.toLowerCase() == "sub-admin";
                  final isPostOwner = widget.post.postOwnerId == currentUserId;

                  return [
                    if (isAdmin || isPostOwner)
                      const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    if (isAdmin || isPostOwner)
                      const PopupMenuItem(
                          value: 'Delete', child: Text('Delete')),
                    if (!isPostOwner)
                      const PopupMenuItem(
                          value: 'Message', child: Text('Message')),
                    const PopupMenuItem(value: 'Report', child: Text('Report')),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          // --- Description ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ExpandableText(text: widget.post.postDescription),
          ),

          // --- Tags (reserve some height to avoid jumps) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: StreamBuilder<List<TagModel>>(
              stream: widget.post.tagStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // fixed-height placeholder to avoid layout shift
                  return _skeletonBox(width: screenWidth * 0.5, height: 18);
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(height: 0);
                }
                final tags = snapshot.data!.map((t) => t.name).toList();
                return ExpandableTags(tags: tags);
              },
            ),
          ),

          // --- Images (ALWAYS reserve height) ---
          StreamBuilder<List<String>>(
            stream: widget.post.imageStream,
            builder: (context, snapshot) {
              // While waiting for the stream, show a placeholder with the fixed height to prevent layout shifts.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: screenHeight * 0.30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(color: Colors.black12),
                    ),
                  ),
                );
              }

              // If there's an error, no data, or the list of image URLs is empty, show nothing.
              if (snapshot.hasError || !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const SizedBox
                    .shrink(); // Renders a widget with zero size.
              }

              // If we have a valid list of URLs, build the image viewer.
              final imageUrls = snapshot.data!;
              return SizedBox(
                height: screenHeight * 0.30,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, idx) {
                    final url = imageUrls[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewImage(),
                              settings: RouteSettings(arguments: {
                                'imageUrls': imageUrls,
                                'initialIndex': idx,
                              }),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (c, _) =>
                                Container(color: Colors.black12),
                            errorWidget: (c, _, __) =>
                                Container(color: Colors.black12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // --- Reactions / Comments (placeholders but fixed size) ---
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
              // likes text or placeholder (same height)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isMetaLoading
                    ? _skeletonBox(width: 80, height: 16)
                    : Text(
                  '$reactionCount likes',
                  key: const ValueKey('likes'),
                  style: const TextStyle(
                    fontFamily: 'SmoochSans',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () =>
                    postViewModel.showComments(context, widget.post.postId),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: isMetaLoading
                    ? _skeletonBox(width: 110, height: 16)
                    : Text(
                  '$commentCount comments',
                  key: const ValueKey('comments'),
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
        ],
      ),
    );
  }
}
