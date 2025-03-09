import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';

import '../../utils/AppColors.dart';

class PetAppreciateView extends StatefulWidget {
  const PetAppreciateView({Key? key}) : super(key: key);

  @override
  _PetAppreciateViewState createState() => _PetAppreciateViewState();
}

class _PetAppreciateViewState extends State<PetAppreciateView> {
  @override
  void initState(){
    super.initState();
    Provider.of<PostViewModel>(context, listen: false).postRepository.getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostViewModel>(
        builder: (context, postViewModel, child) {
          return StreamBuilder<List<PostModel>>(
            stream: postViewModel.posTream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var posts = snapshot.data!;

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.postDescription,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: post.imageUrls.length,
                            itemBuilder: (context, imageIndex) {
                              return CachedNetworkImage(imageUrl: post.imageUrls[imageIndex]);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              onPressed: () {
                                // Implement like functionality here
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                // Implement comment functionality here
                              },
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createpost);
        },
        child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.white),
      ),
    );
  }
}