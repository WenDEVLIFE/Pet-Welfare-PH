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

class PawSomeView extends StatefulWidget {
  const PawSomeView({Key? key}) : super(key: key);

  @override
  PawSomeState createState() => PawSomeState();
}

class PawSomeState extends State<PawSomeView> {
  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPostsData();
  }

  Future<List<Map<String, dynamic>>> _fetchPostsData() async {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);
    List<PostModel> posts = await postViewModel.pawExperiencePostStream.first;
    List<Map<String, dynamic>> postsData = [];

    for (var post in posts) {
      var userReaction = await postViewModel.getUserReaction(post.postId);
      var reactionCount = await postViewModel.getReactionCount(post.postId);
      var commentCount = await postViewModel.getCommentCount(post.postId);

      postsData.add({
        'post': post,
        'userReaction': userReaction,
        'reactionCount': reactionCount,
        'commentCount': commentCount,
      });
    }

    return postsData;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          CustomSearchTextField(
            controller: Provider.of<PostViewModel>(context, listen: false).searchPostController,
            screenHeight: screenHeight,
            hintText: 'Search for posts about paw-some experiences',
            fontSize: 16,
            keyboardType: TextInputType.text,
            onChanged: (searchText) {
              Provider.of<PostViewModel>(context, listen: false).searchPost(searchText);
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No paw-some post available'));
                }

                var postsData = snapshot.data!;

                return ListView.builder(
                  itemCount: postsData.length,
                  itemBuilder: (context, index) {
                    var post = postsData[index]['post'] as PostModel;
                    var userReaction = postsData[index]['userReaction'] as String?;
                    var reactionCount = postsData[index]['reactionCount'] as int;
                    var commentCount = postsData[index]['commentCount'] as int;
                    var formattedDate = Provider.of<PostViewModel>(context, listen: false).formatTimestamp(post.timestamp);
                    bool hasReacted = userReaction != null;

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
                                return Container(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.5,
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
                                          ? ReactionUtils.getReactionIcon(userReaction!)
                                          : Icons.thumb_up_outlined,
                                      color: hasReacted ? ReactionUtils.getReactionColor(userReaction!) : null,
                                    ),
                                    onPressed: () async {
                                      if (hasReacted) {
                                        await Provider.of<PostViewModel>(context, listen: false).removeReaction(post.postId);
                                      } else {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ReactionModal(
                                              onReactionSelected: (reaction) async {
                                                await Provider.of<PostViewModel>(context, listen: false).addReaction(post.postId, reaction);
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
                                      Provider.of<PostViewModel>(context, listen: false).showComments(context, post.postId);
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
            ),
          ),
        ],
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