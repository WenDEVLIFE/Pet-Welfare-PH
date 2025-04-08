import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
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

  final TextEditingController petNameController = TextEditingController();

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
    listenToPost();
    listenToMissingPost();
    listenToFoundPost();
    listenToPawExperiencePost();
    listenToProtectedPost();
    listenToCommunityPost();
    listenToVetAndTravelPost();
    listenToPetAdoptPost();
    listenToCallforAidPost();

  }

  // this is for the set post
  void setPost(List<PostModel> posts, {bool notify = true}) {
    _posts = posts;
    filteredPost = posts;
    searchPost(searchPostController.text);
  }

  // this is for the set missing post
  void setMissingPost(List<PostModel> posts, {bool notify = true}) {
    missingPost = posts;
    filterMissingPost = posts;
    searchMissingPost(searchPostController.text);
  }

  // this is for the set found post
  void setFoundPost(List<PostModel> posts, {bool notify = true}) {
    foundPost = posts;
    filterFoundPost = posts;
    searchFoundPost(searchPostController.text);
  }

  // this is for the set paw experience post
  void setPawExperiencePost(List<PostModel> posts, {bool notify = true}) {
    pawExperiencePost = posts;
    filterPawExperiencePost = posts;
    searchPawExperience(searchPostController.text);
  }

  // this is for the set protected post
  void setProtectedPost(List<PostModel> posts, {bool notify = true}) {
    protectedPost = posts;
    filterProtectedPost = posts;
    searchProtectedPost(searchPostController.text);
  }

  // this is for the set community post
  void setCommunityPost(List<PostModel> posts, {bool notify = true}) {
    communityPost = posts;
    filterCommunityPost = posts;
    searchCommunityPost(searchPostController.text);
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

  void listenToPost() async {
    posTream.listen((posts) {
      _posts = posts;
      filteredPost = posts;
      notifyListeners();
    });
  }

  // Listen to missing post
  void listenToMissingPost() async {
    missingPostStream.listen((missingPosts) {
      missingPost = missingPosts;
      filterMissingPost = missingPosts;
      notifyListeners();
    });
  }

  // Listen to found post
  void listenToFoundPost() {
    foundPostStream.listen((foundPosts) async{
      foundPost = foundPosts;
      filterFoundPost = foundPosts;
      notifyListeners();
    });
  }

  // Listen to paw experience post
  void listenToPawExperiencePost() async {
    pawExperiencePostStream.listen((pawExperiencePosts) {
      pawExperiencePost = pawExperiencePosts;
      filterPawExperiencePost = pawExperiencePosts;
      notifyListeners();
    });
  }

  // Listen to protected post
  void listenToProtectedPost() async {
    protectedPostStream.listen((protectedPosts) {
      protectedPost = protectedPosts;
      filterProtectedPost = protectedPosts;
      notifyListeners();
    });
  }

  // Listen to community post
  void listenToCommunityPost() async{
    communityPostStream.listen((communityPosts) {
      communityPost = communityPosts;
      filterCommunityPost = communityPosts;
      notifyListeners();
    });
  }

  // Listen to vet and travel post
  void listenToVetAndTravelPost() async {
    vetAndTravelPostStream.listen((travelPosts) {
      vetAndtravelPost = travelPosts;
      filterVetAndTravelPost = travelPosts;
      notifyListeners();
    });
  }

  // Listen to pet adopt post
  void listenToPetAdoptPost() async {
    petAdoptPostStream.listen((adoptpost) {
      petAdoptPost = adoptpost;
      filterPetAdoptPost = adoptpost;
      notifyListeners();
    });
  }

  // Listen to call for aid post
  void listenToCallforAidPost() async {
    callforAidPostStream.listen((aidPost) {
      callforAidPost = aidPost;
      filterCallforAidPost = aidPost;
      notifyListeners();
    });
  }
  // search post
  void searchPost(String search) {
    if (search.isEmpty) {
      filteredPost = _posts;
    } else {
      filteredPost = _posts.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))).toList();
    }
    notifyListeners();
  }

  // Missing Post
  void searchMissingPost(String searchText) {
    if (searchText.isEmpty) {
      filterMissingPost = missingPost;
    } else {
      filterMissingPost = missingPost.where((post) =>
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
          post.PetType.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
    notifyListeners();
  }

  // Found Post
  void searchFoundPost(String searchText) {
    if (searchText.isEmpty) {
      filterFoundPost = foundPost;
    } else {
      filterFoundPost = foundPost.where((post) =>
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
          post.PetType.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
    notifyListeners();
  }

  // Paw Experience Post
  void searchPawExperience(String search) {
    if (search.isEmpty) {
      filterPawExperiencePost = pawExperiencePost;
    } else {
      filterPawExperiencePost = pawExperiencePost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))).toList();
    }
    notifyListeners();
  }

  // Protected Post
  void searchProtectedPost(String search) {
    if (search.isEmpty) {
      filterProtectedPost = protectedPost;
    } else {
      filterProtectedPost = protectedPost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))).toList();
    }
    notifyListeners();
  }


  // Community Post
  void searchCommunityPost(String search) {
    if (search.isEmpty) {
      filterCommunityPost.addAll(communityPost);
    } else {
      filterCommunityPost.addAll(communityPost.where((post) => post.postDescription.toLowerCase().contains(search.toLowerCase())));
    }
    notifyListeners();
  }

  // Vet and Travel Post
  void searchVetAndTravelPost(String search) {
    if (search.isEmpty) {
      filterVetAndTravelPost = vetAndtravelPost;
    } else {
      filterVetAndTravelPost = vetAndtravelPost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))).toList();
    }
    notifyListeners();
  }

  // Pet Adopt Post
  void searchPetAdoptPost(String search) {
    if (search.isEmpty) {
      filterPetAdoptPost = petAdoptPost;
    } else {
     filterPetAdoptPost = petAdoptPost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))
         || post.petNameAdopt.toLowerCase().contains(search.toLowerCase()) || post.petBreedAdopt.toLowerCase().contains(search.toLowerCase())
         || post.petAgeAdopt.toLowerCase().contains(search.toLowerCase()) || post.petGenderAdopt.toLowerCase().contains(search.toLowerCase()) ||
         post.petColorAdopt.toLowerCase().contains(search.toLowerCase()) || post.petSizeAdopt.toLowerCase().contains(search.toLowerCase())
         || post.petAddressAdopt.toLowerCase().contains(search.toLowerCase()) || post.regProCiBagAdopt.toLowerCase().contains(search.toLowerCase())
          || post.dateAdopt.toLowerCase().contains(search.toLowerCase()) || post.petTypeAdopt.toLowerCase().contains(search.toLowerCase())
     ).toList();
    }
    notifyListeners();
  }

  // Search PawSome Post
  void searchPawSome(String searchText) {
    if (searchText.isEmpty) {
      filterPawExperiencePost = pawExperiencePost;
    } else {
      filterPawExperiencePost = pawExperiencePost.where((post) =>
          post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase()))).toList();
    }
    notifyListeners();
  }

  // Search Call for Aid Post
  void searchCallforAidPost(String searchText) {
    if (searchText.isEmpty) {
      filterCallforAidPost = callforAidPost;
    } else {
      filterCallforAidPost = callforAidPost.where((post) =>post.bankHolder.toLowerCase().contains(searchText.toLowerCase()) ||
          post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) || post.postDescription.toLowerCase().contains(searchText.toLowerCase()) ||
          post.accountNumber.toLowerCase().contains(searchText.toLowerCase()) ||  post.estimatedAmount.toLowerCase().contains(searchText.toLowerCase())
          ||  post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||  post.donationType.toLowerCase().contains(searchText.toLowerCase())
          ||  post.statusDonation.toLowerCase().contains(searchText.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  // This is for multiple search for pet adoption
  Future<void> startSearchPetAdoption(Map<String, dynamic> searchParams) async {
    print('🔍 Starting search with parameters: $searchParams');

    filterPetAdoptPost = petAdoptPost.where((post) {
      final postFields = {
        'region': post.petRegionAdopt,
        'province': post.petProvinceAdopt,
        'city': post.petCityAdopt,
      };
      for (var post in petAdoptPost) {
        print('🧪 petType: ${post.petTypeAdopt}');
        print('🧪 post object: $post');
      }
      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString() ?? '';

        if (value.trim().isEmpty) continue;
        final postValue = (postFields[key] ?? '').toString();

        if (!debugEquals(key, postValue, value)) {
          return false;
        }
      }

      return true;
    }).toList();

    print('📦 Filtered posts: ${filterPetAdoptPost.length}');
    notifyListeners();
  }


  // This is for multiple search for found pets
  Future <void> startSearchFoundPets(Map<String, dynamic> searchParams) async{

    filterFoundPost = foundPost.where((post) {
      final postFields = {
        'region': post.petRegion,
        'province': post.petProvince,
        'city': post.petCity,
      };
      for (var post in foundPost) {
        print('🧪 petType: ${post.petTypeAdopt}');
        print('🧪 post object: $post');
      }
      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString() ?? '';

        if (value.trim().isEmpty) continue;
        final postValue = (postFields[key] ?? '').toString();

        if (!debugEquals(key, postValue, value)) {
          return false;
        }
      }

      return true;
    }).toList();

  }

  // This is for multiple search for missing pets
  Future <void> startSearchMissingPets(Map<String, dynamic> searchParams) async{
    filterMissingPost = missingPost.where((post) {
      final postFields = {
        'region': post.petRegion,
        'province': post.petProvince,
        'city': post.petCity,
      };
      for (var post in missingPost) {
        print('🧪 petType: ${post.petTypeAdopt}');
        print('🧪 post object: $post');
      }
      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString() ?? '';

        if (value.trim().isEmpty) continue;
        final postValue = (postFields[key] ?? '').toString();

        if (!debugEquals(key, postValue, value)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
  // for checking matching for debugging
  bool debugEquals(String key, String value1, String value2) {
    value1 = value1.toLowerCase().trim();
    value2 = value2.toLowerCase().trim();

    bool isEqual = value1 == value2;

    if (!isEqual) {
      print('🔍 MISMATCH on "$key": "$value1" ≠ "$value2"');
    } else {
      print('✅ MATCH on "$key": "$value1" == "$value2"');
    }

    return isEqual;
  }


}