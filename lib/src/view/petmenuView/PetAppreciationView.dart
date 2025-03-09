import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  var formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(post.timestamp.toDate()); // Format the timestamp

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
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
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
                                width: screenWidth * 0.8, // Adjust the width as needed
                                height: screenHeight * 0.5, // Adjust the height as needed
                                child: CachedNetworkImage(
                                  imageUrl: post.imageUrls[imageIndex],
                                  fit: BoxFit.cover, // Adjust the fit as needed
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
                                  icon: Icon(Icons.thumb_up),
                                  onPressed: () {
                                    // Implement like functionality here
                                  },
                                ),
                                Text('0 likes',  style: const TextStyle(
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () {
                                    // Implement comment functionality here
                                  },
                                ),
                                Text('0 comments' , style: const TextStyle(
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
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