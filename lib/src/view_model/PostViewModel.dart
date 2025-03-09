import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController searchPostController = TextEditingController();

  final List<PostModel> _posts = [];

  final List <PostModel> filteredPost = [];

  final PostRepository postRepository = PostRepositoryImpl();

  Stream <List<PostModel>> get posTream => postRepository.getPosts();



}