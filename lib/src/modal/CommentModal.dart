import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/model/CommentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/SessionManager.dart';

class CommentModal extends StatefulWidget {
  final String postId;

  CommentModal({required this.postId});

  @override
  _CommentModalState createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  late TextEditingController commentController;
  SessionManager sessionManager = SessionManager();
  var role;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    currentUser = FirebaseAuth.instance.currentUser!;
    loadRole();
  }

  Future<void> loadRole() async {
    var userdata = await sessionManager.getUserInfo();
    setState(() {
      role = userdata!['role'];
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> editComment(String postId, String commentId, String newCommentText) async {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);
    await postViewModel.editComment(postId, commentId, newCommentText);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: postViewModel.getComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No comments available'));
                }

                var comments = snapshot.data!;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    bool canEditOrDelete = currentUser.uid == comment.userid || role == 'Admin' || role == 'Sub-Admin';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(comment.profileUrl),
                            radius: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.Name,
                                  style: const TextStyle(
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  comment.commentText,
                                  style: const TextStyle(
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  comment.formattedTimestamp,
                                  style: const TextStyle(
                                    fontFamily: 'SmoochSans',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (canEditOrDelete)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController editController = TextEditingController(text: comment.commentText);
                                        return AlertDialog(
                                          title: const Text('Edit Comment'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: const InputDecoration(
                                              labelText: 'Edit your comment',
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              children: [
                                                Expanded(child: Container()),
                                                TextButton(
                                                  onPressed: () async {
                                                    if (editController.text.isNotEmpty) {
                                                      await editComment(widget.postId, comment.commendID, editController.text);
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  child: CustomText(
                                                    text: "Save",
                                                    size: 16,
                                                    color: Colors.black,
                                                    weight: FontWeight.w700 ,
                                                    align: TextAlign.left,
                                                    screenHeight: screenHeight,
                                                    alignment: Alignment.centerRight,

                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CustomText(
                                                    text: "Cancel",
                                                    size: 16,
                                                    color: Colors.black,
                                                    weight: FontWeight.w700 ,
                                                    align: TextAlign.left,
                                                    screenHeight: screenHeight,
                                                    alignment: Alignment.centerRight,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await postViewModel.deleteComment(widget.postId, comment.commendID);
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
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (commentController.text.isNotEmpty) {
                      await postViewModel.addComment(widget.postId, commentController.text);
                      commentController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}