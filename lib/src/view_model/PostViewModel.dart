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

  List<PostModel> missingPost = [];
  List<PostModel> filterMissingPost = [];

  List<PostModel> foundPost = [];
  List<PostModel> filterFoundPost = [];

  List<PostModel> pawExperiencePost = [];
  List<PostModel> filterPawExperiencePost = [];

  List<PostModel> protectedPost = [];
  List<PostModel> filterProtectedPost = [];

  List<PostModel> communityPost = [];
  List<PostModel> filterCommunityPost = [];

  List<PostModel> vetAndtravelPost = [];
  List<PostModel> filterVetAndTravelPost = [];

  List<PostModel> petAdoptPost = [];
  List<PostModel> filterPetAdoptPost = [];

  List<PostModel> callforAidPost = [];
  List<PostModel> filterCallforAidPost = [];

  List<CommentModel> comments = [];

  final PostRepository postRepository = PostRepositoryImpl();

  Stream<List<PostModel>> get posTream => postRepository.getPosts();
  Stream<List<PostModel>> get missingPostStream => postRepository.getMissingPosts();
  Stream<List<PostModel>> get foundPostStream => postRepository.getFoundPost();
  Stream<List<PostModel>> get pawExperiencePostStream => postRepository.getPawExperiencePost();
  Stream<List<PostModel>> get protectedPostStream => postRepository.getProtectPetPost();
  Stream<List<PostModel>> get communityPostStream => postRepository.getCommunityPost();
  Stream<List<PostModel>> get vetAndTravelPostStream => postRepository.getVetAndTravelPost();
  Stream<List<PostModel>> get petAdoptPostStream => postRepository.getPetAdoption();
  Stream<List<PostModel>> get callforAidPostStream => postRepository.getCallforAid();

 // Initialize the PostViewModel
  PostViewModel() {
    searchPostController.addListener(() {
      searchPost(searchPostController.text);
    });
  }

  // this is for the set post
  void setPost(List<PostModel> posts, {bool notify = true}) {
    _posts = posts;
    searchPost(searchPostController.text);
  }

  // get format timestap
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


  // check if user has react
  Future<bool> hasUserReacted(String postId) async {
    return await postRepository.hasUserReacted(postId);
  }

  // get user reactions
  Future<String?> getUserReaction(String postId) async {
    return await postRepository.getUserReaction(postId);
  }

  // get reactions
  Future<int> getReactionCount(String postId) async {
    return await postRepository.getReactionCount(postId);
  }

  // get comment
  Future<int> getCommentCount(String postId) async {
    return await postRepository.getCommentCount(postId);
  }

  // remove reactions
  Future<void> removeReaction(String postId) async {
    try {
      await postRepository.removeReaction(postId);
    } catch (e) {
      throw Exception('Failed to remove reaction: $e');
    }
  }

  // Add reaction
  Future <void> addReaction(String postId, String reaction) async{
   try{
     await postRepository.addReaction(postId, reaction);
   }
    catch(e){
      throw Exception('Failed to add reaction: $e');
    }
  }

  // add comment
  Future<void> addComment(String postId, String commentText) async {
    try {
      await postRepository.addComment(postId, commentText);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // get comments
  Stream<List<CommentModel>> getComments(String postId) {
    return postRepository.getComments(postId);
  }

  // Show comments
  void showComments(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CommentModal(postId: postId);
      },
    );
  }

  // Delete the comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepository.deleteComment(postId, commentId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> editComment(String postId, String commentId, String newCommentText) async {
    try {
      await postRepository.editComment(postId, commentId, newCommentText);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to edit comment: $e');
    }
  }

  // search post
  void searchPost(String search) {
    filteredPost.clear();
    if (search.isEmpty) {
      filteredPost.addAll(_posts);
    } else {
      filteredPost.addAll(_posts.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Missing Post
  void searchMissingPost(String searchText) {
   filterMissingPost.clear();
    if (searchText.isEmpty) {
      filterMissingPost.addAll(missingPost);
    } else {
      filterMissingPost.addAll(missingPost.where((post) => post.postDescription.toLowerCase().contains(
          searchText.toLowerCase()) ||
          post.petName.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petType.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petBreed.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petGender.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petAge.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petColor.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petAddress.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petCollar.toLowerCase().contains(searchText.toLowerCase()) ||
          post.regProCiBag.toLowerCase().contains(searchText.toLowerCase()) ||
          post.date.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petSize.toLowerCase().contains(searchText.toLowerCase()) ||
          post.PetType.toLowerCase().contains(searchText.toLowerCase())));
    }
    notifyListeners();
  }

  // Found Post
  void searchFoundPost(String searchText) {
    filterFoundPost.clear();
    if (searchText.isEmpty) {
      filterFoundPost.addAll(foundPost);
    } else {
      filterFoundPost.addAll(foundPost.where((post) => post.postDescription.toLowerCase().contains(
          searchText.toLowerCase()) ||
          post.petName.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petType.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petBreed.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petGender.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petAge.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petColor.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petAddress.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petCollar.toLowerCase().contains(searchText.toLowerCase()) ||
          post.regProCiBag.toLowerCase().contains(searchText.toLowerCase()) ||
          post.date.toLowerCase().contains(searchText.toLowerCase()) ||
          post.petSize.toLowerCase().contains(searchText.toLowerCase()) ||
          post.PetType.toLowerCase().contains(searchText.toLowerCase())));
    }
    notifyListeners();
  }

  // Paw Experience Post
  void searchPawExperience(String search) {
    filterPawExperiencePost.clear();
    if (search.isEmpty) {
      filterPawExperiencePost.addAll(pawExperiencePost);
    } else {
      filterPawExperiencePost.addAll(pawExperiencePost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Protected Post
  void searchProtectedPost(String search) {
    filterProtectedPost.clear();
    if (search.isEmpty) {
      filterProtectedPost.addAll(protectedPost);
    } else {
      filterProtectedPost.addAll(protectedPost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }


  // Community Post
  void searchCommunityPost(String search) {
    filterCommunityPost.clear();
    if (search.isEmpty) {
      filterCommunityPost.addAll(communityPost);
    } else {
      filterCommunityPost.addAll(communityPost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Vet and Travel Post
  void searchVetAndTravelPost(String search) {
    filterVetAndTravelPost.clear();
    if (search.isEmpty) {
      filterVetAndTravelPost.addAll(vetAndtravelPost);
    } else {
      filterVetAndTravelPost.addAll(vetAndtravelPost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Pet Adopt Post
  void searchPetAdoptPost(String search) {
    filterPetAdoptPost.clear();
    if (search.isEmpty) {
      filterPetAdoptPost.addAll(petAdoptPost);
    } else {
      filterPetAdoptPost.addAll(petAdoptPost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Search PawSome Post
  void searchPawSome(String searchText) {
    filterPawExperiencePost.clear();
    if (searchText.isEmpty) {
      filterPawExperiencePost.addAll(pawExperiencePost);
    } else {
      filterPawExperiencePost.addAll(pawExperiencePost.where((post) => post.postDescription.toLowerCase().contains(
          searchText.toLowerCase())));
    }
    notifyListeners();
  }

  // Search Call for Aid Post
  void searchCallforAidPost(String searchText) {
    filterCallforAidPost.clear();
    if (searchText.isEmpty) {
      filterCallforAidPost.addAll(callforAidPost);
    } else {
      filterCallforAidPost.addAll(callforAidPost.where((post) => post.postDescription.toLowerCase().contains(
          searchText.toLowerCase()) || post.bankHolder.toLowerCase().contains(searchText.toLowerCase()) ||
          post.accountNumber.toLowerCase().contains(searchText.toLowerCase()) ||  post.estimatedAmount.toLowerCase().contains(searchText.toLowerCase())
          ||  post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||  post.donationType.toLowerCase().contains(searchText.toLowerCase())
          ||  post.statusDonation.toLowerCase().contains(searchText.toLowerCase())
      ));
    }
    notifyListeners();
  }

}