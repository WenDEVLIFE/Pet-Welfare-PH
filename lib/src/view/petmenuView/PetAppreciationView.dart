import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/modal/ReactionModal.dart';

import '../../utils/AppColors.dart';
import '../../utils/ReactionUtils.dart';
import '../../widgets/SearchTextField.dart';
import '../ViewImage.dart';

class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({Key? key}) : super(key: key);

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  @override
  void initState() {
    super.initState();
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
                hintText: 'Search for pets for pet appreciation',
                fontSize: 16,
                keyboardType: TextInputType.text,
                onChanged: (searchText) {
                  postViewModel.searchPost(searchText);
                },
              ),
              Expanded(
                child: StreamBuilder<List<PostModel>>(
                  stream: postViewModel.posTream, // Stream of posts
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No posts available'));
                    }

                    var posts = snapshot.data!;

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      hasReacted
                                                          ? ReactionUtils.getReactionIcon(userReaction!)
                                                          : Icons.thumb_up_outlined,
                                                      color: hasReacted ? ReactionUtils.getReactionColor(userReaction!) : null,
                                                    ),
                                                    onPressed: () async {
                                                      if (hasReacted) {
                                                        await postViewModel.removeReaction(post.postId);
                                                      } else {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return ReactionModal(
                                                              onReactionSelected: (reaction) async {
                                                                await postViewModel.addReaction(post.postId, reaction);
                                                                setState(() {});
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                      setState(() {});
                                                    },
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
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'uniqueTag',
        backgroundColor: AppColors.orange,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createpost);
        },
        child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.white),
      ),
    );
  }
}