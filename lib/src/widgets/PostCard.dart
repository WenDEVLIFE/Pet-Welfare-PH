import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    var formattedDate = postViewModel.formatTimestamp(post.timestamp);

    return FutureBuilder<String?>(
      future: postViewModel.getUserReaction(post.postId),
      builder: (context, userReactionSnapshot) {
        if (userReactionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        String? userReaction = userReactionSnapshot.data;
        bool hasReacted = userReaction != null;

        return FutureBuilder<int>(
          future: postViewModel.getReactionCount(post.postId),
          builder: (context, reactionCountSnapshot) {
            if (reactionCountSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            int reactionCount = reactionCountSnapshot.data ?? 0;

            return FutureBuilder<int>(
              future: postViewModel.getCommentCount(post.postId),
              builder: (context, commentCountSnapshot) {
                if (commentCountSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                int commentCount = commentCountSnapshot.data ?? 0;

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
                                  child: const Text('Delete'),
                                  onTap: () {
                                    // Handle edit action
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
                                Navigator.pushNamed(
                                  context,
                                  '/viewImage',
                                  arguments: {
                                    'imageUrls': post.imageUrls,
                                    'initialIndex': imageIndex,
                                  },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  hasReacted
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  color: hasReacted ? Colors.blue : null,
                                ),
                                onPressed: () async {
                                  if (hasReacted) {
                                    await postViewModel.removeReaction(post.postId);
                                  } else {
                                    await postViewModel.addReaction(post.postId, 'like');
                                  }
                                },
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
              },
            );
          },
        );
      },
    );
  }
}