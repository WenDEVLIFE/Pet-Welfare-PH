import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController searchPostController = TextEditingController();

  List<PostModel> _posts = [];
  List<PostModel> filteredPost = [];

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
}