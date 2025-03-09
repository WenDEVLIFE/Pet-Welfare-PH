import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController searchPostController = TextEditingController();

  List<PostModel> _posts = [];
  List<PostModel> filteredPost = [];

  final PostRepository postRepository = PostRepositoryImpl();

  Stream<List<PostModel>> get posTream => postRepository.getPosts();

  PostViewModel() {
    posTream.listen((posts) {
      _posts = posts;
      searchPost(searchPostController.text);
      print(_posts);
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

  void addPost() {
    print(_posts);
    notifyListeners();
  }
}