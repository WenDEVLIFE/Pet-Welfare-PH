import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:pet_welfrare_ph/src/utils/SessionManager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../modal/CommentModal.dart';
import '../model/CommentModel.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController searchPostController = TextEditingController();
  String role = '';

  List<PostModel> _posts = [];
  List<PostModel> filteredPost = [];

  List<CommentModel> comments = [];

 // Stream <List<CommentModel>> get commentStream => postRepository.getComments();

  final PostRepository postRepository = PostRepositoryImpl();

  Stream<List<PostModel>> get posTream => postRepository.getPosts();

  PostViewModel() {


    searchPostController.addListener(() {
      searchPost(searchPostController.text);
    });
  }

  void searchPost(String search) {
    filteredPost.clear();
    if (search.isEmpty) {
      filteredPost.addAll(_posts);
    } else {
      filteredPost.addAll(_posts.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  void setPost(List<PostModel> posts, {bool notify = true}) {
    _posts = posts;
    searchPost(searchPostController.text);

  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime postDate = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(postDate);

    if (difference.inDays > 7) {
      return DateFormat('yyyy-MM-dd – kk:mm').format(postDate);
    } else {
      return timeago.format(postDate);
    }
  }


  Future<bool> hasUserReacted(String postId) async {
    return await postRepository.hasUserReacted(postId);
  }

  Future<String?> getUserReaction(String postId) async {
    return await postRepository.getUserReaction(postId);
  }

  Future<int> getReactionCount(String postId) async {
    return await postRepository.getReactionCount(postId);
  }

  Future<void> removeReaction(String postId) async {
    try {
      await postRepository.removeReaction(postId);
    } catch (e) {
      throw Exception('Failed to remove reaction: $e');
    }
  }

  Future <void> addReaction(String postId, String reaction) async{
   try{
     await postRepository.addReaction(postId, reaction);
   }
    catch(e){
      throw Exception('Failed to add reaction: $e');
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    try {
      await postRepository.addComment(postId, commentText);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return postRepository.getComments(postId);
  }

  void showComments(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CommentModal(postId: postId);
      },
    );
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}