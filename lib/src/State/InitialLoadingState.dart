import 'dart:async';

import '../model/PostModel.dart';

class PostCategoryState {
  bool isLoading = true;
  List<PostModel> posts = [];
  List<PostModel> filteredPosts = [];
  StreamSubscription? subscription;
}