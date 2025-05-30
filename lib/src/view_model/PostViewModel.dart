import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../modal/CommentModal.dart';
import '../model/CommentModel.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import '../utils/ToastComponent.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController searchPostController = TextEditingController();
  String role = '';
  String currentUserId = '';

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

  List<PostModel> petforRescuePost = [];
  List<PostModel> filterPetForRescuePost = [];

  List<PostModel> myPostlist = [];
  List<PostModel> filterMyPost = [];

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
  Stream<List<PostModel>> get petForRescue => postRepository.getFindHome();
  Stream<List<PostModel>> get myPost => postRepository.getMyPost();

  List<String> petStatusOptions =[];
  String? selectedPetStatus;

 // Initialize the PostViewModel
  PostViewModel() {
    searchPostController.addListener(() {
      searchPost(searchPostController.text);
    });

    initializeListeners();
  }

  Future<void> initializeListeners() async {
    await Future.wait(<Future<dynamic>>[
      loadData(),
    ]);
  }

  // initialize role and current user id
  Future <void> loadData() async{
     final sessionManager = SessionManager();
      sessionManager.getUserInfo().then((userData) {
       role = userData!['role'] ?? '';
       currentUserId = userData!['uid'] ?? '';
       notifyListeners();
     });
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

  // this is for the set vet and travel post
  void setVetAndTravelPost(List<PostModel> posts, {bool notify = true}) {
    vetAndtravelPost = posts;
    filterVetAndTravelPost = posts;
    searchVetAndTravelPost(searchPostController.text);
  }

  // this is for the set pet adopt post
  void setPetAdoptPost(List<PostModel> posts, {bool notify = true}) {
    petAdoptPost = posts;
    filterPetAdoptPost = posts;
    searchPetAdoptPost(searchPostController.text);
  }

  // This is for the set call for aid post
  void setCallforAidPost(List<PostModel> posts, {bool notify = true}) {
    callforAidPost = posts;
    filterCallforAidPost = posts;
    searchCallforAidPost(searchPostController.text);
  }

  // this is for the set pet for rescue post
  void setPetForRescuePost(List<PostModel> posts, {bool notify = true}) {
    petforRescuePost = posts;
    filterPetForRescuePost = posts;
    searchPetForRescue(searchPostController.text);
  }

  // this is for the set my post
  void setMyPost(List<PostModel> posts, {bool notify = true}) {
    myPostlist = posts;
    filterMyPost = posts;
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

  Future <void> listenToPost() async {
    posTream.listen((posts) {
      _posts = posts;
      filteredPost = posts;
      notifyListeners();
    });
  }

  // Listen to missing post
  Future <void> listenToMissingPost() async {
    missingPostStream.listen((missingPosts) {
      missingPost = missingPosts;
      filterMissingPost = missingPosts;
      notifyListeners();
    });
  }

  // Listen to found post
  Future  <void> listenToFoundPost()  async {
    foundPostStream.listen((foundPosts) {
      foundPost = foundPosts;
      filterFoundPost = foundPosts;
      notifyListeners();
    });
  }

  // Listen to paw experience post
  Future <void> listenToPawExperiencePost() async {
    pawExperiencePostStream.listen((pawExperiencePosts) {
      pawExperiencePost = pawExperiencePosts;
      filterPawExperiencePost = pawExperiencePosts;
      notifyListeners();
    });
  }

  // Listen to protected post
  Future <void> listenToProtectedPost() async {
    protectedPostStream.listen((protectedPosts) {
      protectedPost = protectedPosts;
      filterProtectedPost = protectedPosts;
      notifyListeners();
    });
  }

  // Listen to community post
  Future <void> listenToCommunityPost() async{
    communityPostStream.listen((communityPosts) {
      communityPost = communityPosts;
      filterCommunityPost = communityPosts;
      notifyListeners();
    });
  }

  // Listen to vet and travel post
  Future <void> listenToVetAndTravelPost() async {
    vetAndTravelPostStream.listen((travelPosts) {
      vetAndtravelPost = travelPosts;
      filterVetAndTravelPost = travelPosts;
      notifyListeners();
    });
  }

  // Listen to pet adopt post
  Future <void> listenToPetAdoptPost() async {
    petAdoptPostStream.listen((adoptpost) {
      petAdoptPost = adoptpost;
      filterPetAdoptPost = adoptpost;
      notifyListeners();
    });
  }

  // Listen to call for aid post
  Future <void> listenToCallforAidPost() async {
    callforAidPostStream.listen((aidPost) {
      callforAidPost = aidPost;
      filterCallforAidPost = aidPost;
      notifyListeners();
    });
  }

  // Listen to pet for rescue post
  Future <void> listenToPetForRescuePost() async {
    petForRescue.listen((rescuePost) {
      petforRescuePost = rescuePost;
      filterPetForRescuePost = rescuePost;
      notifyListeners();
    });
  }

  // Listen to my post
  Future <void> listenToMyPost() async {
    myPost.listen((myPosts) {
      myPostlist = myPosts;
      filterMyPost = myPosts;
      notifyListeners();
    });
  }


  // search post
  void searchPost(String search) {
    if (search.isEmpty) {
      filteredPost = _posts;
    } else {
      filteredPost = _posts.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))
          ||   post.postOwnerName.toLowerCase().contains(search)).toList();
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
          post.postOwnerName.toLowerCase().contains(searchText) ||
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
          post.postOwnerName.toLowerCase().contains(searchText) ||
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
      filterPawExperiencePost = pawExperiencePost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))
          ||   post.postOwnerName.toLowerCase().contains(search)).toList();
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
      filterCommunityPost.addAll(communityPost.where((post) =>
          post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase())) ||
          post.postOwnerName.toLowerCase().contains(search)).toList());
    }
    notifyListeners();
  }

  // Vet and Travel Post
  void searchVetAndTravelPost(String search) {
    if (search.isEmpty) {
      filterVetAndTravelPost = vetAndtravelPost;
    } else {
      filterVetAndTravelPost = vetAndtravelPost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))
          ||   post.postOwnerName.toLowerCase().contains(search) ).toList();
    }
    notifyListeners();
  }

  // Pet Adopt Post
  void searchPetAdoptPost(String search) {
    if (search.isEmpty) {
      filterPetAdoptPost = petAdoptPost;
    } else {
     filterPetAdoptPost = petAdoptPost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(search.toLowerCase()))
         || post.postOwnerName.toLowerCase().contains(search)
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
         post.postOwnerName.toLowerCase().contains(searchText) ||
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
          post.postOwnerName.toLowerCase().contains(searchText) ||
          post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) || post.postDescription.toLowerCase().contains(searchText.toLowerCase()) ||
          post.accountNumber.toLowerCase().contains(searchText.toLowerCase()) ||  post.estimatedAmount.toLowerCase().contains(searchText.toLowerCase())
          ||  post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||  post.donationType.toLowerCase().contains(searchText.toLowerCase())
          ||  post.statusDonation.toLowerCase().contains(searchText.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  // Search Pet for Rescue Post
  void searchPetForRescue(String searchText) {

    if (searchText.isEmpty) {
      filterPetForRescuePost = petforRescuePost;
    } else {
      filterPetForRescuePost = petforRescuePost.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
          post.postOwnerName.toLowerCase().contains(searchText)
          || post.rescuePetSize.toLowerCase().contains(searchText.toLowerCase()) || post.rescueStatus.toLowerCase().contains(searchText.toLowerCase())
      ||post.rescueAddress.toLowerCase().contains(searchText.toLowerCase()) || post.rescuePetColor.toLowerCase().contains(searchText.toLowerCase())
          || post.rescueBreed.toLowerCase().contains(searchText.toLowerCase()) || post.petType.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
    notifyListeners();

  }

  // This will search user post
  void searchMyPost(String searchText){
     if (searchText.isEmpty) {
       filterMyPost = myPostlist;
     }
      else {
        filterMyPost = myPostlist.where((post) => post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
            post.postOwnerName.toLowerCase().contains(searchText)
            || post.rescuePetSize.toLowerCase().contains(searchText.toLowerCase()) || post.rescueStatus.toLowerCase().contains(searchText.toLowerCase())
            ||post.rescueAddress.toLowerCase().contains(searchText.toLowerCase()) || post.rescuePetColor.toLowerCase().contains(searchText.toLowerCase())
        || post.establisHment_Clinic_Name.toLowerCase().contains(searchText.toLowerCase()) || post.establismentRegion.toLowerCase().contains(searchText.toLowerCase())
            || post.establismentProvinces.toLowerCase().contains(searchText.toLowerCase()) || post.establismentCity.toLowerCase().contains(searchText.toLowerCase())
            || post.petNameAdopt.toLowerCase().contains(searchText.toLowerCase()) || post.petBreedAdopt.toLowerCase().contains(searchText.toLowerCase())
            || post.petAgeAdopt.toLowerCase().contains(searchText.toLowerCase()) || post.petGenderAdopt.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petColorAdopt.toLowerCase().contains(searchText.toLowerCase()) || post.petSizeAdopt.toLowerCase().contains(searchText.toLowerCase())
            || post.petAddressAdopt.toLowerCase().contains(searchText.toLowerCase()) || post.regProCiBagAdopt.toLowerCase().contains(searchText.toLowerCase())
            || post.dateAdopt.toLowerCase().contains(searchText.toLowerCase()) || post.petTypeAdopt.toLowerCase().contains(searchText.toLowerCase())
            || post.bankHolder.toLowerCase().contains(searchText.toLowerCase()) ||
            post.accountNumber.toLowerCase().contains(searchText.toLowerCase()) ||  post.estimatedAmount.toLowerCase().contains(searchText.toLowerCase())
            ||  post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||  post.donationType.toLowerCase().contains(searchText.toLowerCase())
            ||  post.statusDonation.toLowerCase().contains(searchText.toLowerCase())
            || post.petName.toLowerCase().contains(searchText.toLowerCase()) ||
            post.postOwnerName.toLowerCase().contains(searchText) ||
            post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) || post.postDescription.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petType.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petBreed.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petGender.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petAge.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petColor.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petAddress.toLowerCase().contains(searchText.toLowerCase()) ||
            post.petCollar.toLowerCase().contains(searchText.toLowerCase()) ||
            post.rescueBreed.toLowerCase().contains(searchText.toLowerCase()) || post.petType.toLowerCase().contains(searchText.toLowerCase())).toList();
      }
  }


  // This is for multiple search for pet adoption
  Future<void> startSearchPetAdoption(Map<String, dynamic> searchParams) async {
    print('🔍 Starting search with parameters: $searchParams');

    // Filter logic
    filterPetAdoptPost = petAdoptPost.where((post) {
      final postFields = {
        'petType': post.petTypeAdopt,
        'petSize': post.petSizeAdopt,
        'petGender': post.petGenderAdopt,
        'colorPattern': post.petColorAdopt,
        'region': post.petRegionAdopt,
        'province': post.petProvinceAdopt,
        'city': post.petCityAdopt,
        'barangay': post.petBarangayAdopt,
      };

      // Add breed dynamically based on PetTypeAdopt
      if (post.petTypeAdopt?.toLowerCase() == 'dog') {
        postFields['dogBreed'] = post.petBreedAdopt;
      } else if (post.petTypeAdopt?.toLowerCase() == 'cat') {
        postFields['catBreed'] = post.petBreedAdopt;
      }

      final petType = (searchParams['petType'] ?? '').toString().toLowerCase();

      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString().toLowerCase().trim();

        if (value == null || value.isEmpty) continue;

        // Skip wrong breed type
        if ((key == 'dogBreed' && petType != 'dog') || (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue = (postFields[key] ?? '').toString().toLowerCase().trim();

        print('🔎 Comparing "$postValue" with "$value" for key "$key"');

        if (postValue != value) {
          print('❌ Not matched: $key');
          return false;
        }
      }

      print('✅ Post matched!');
      return true;
    }).toList();

    print('📦 Filtered posts: ${filterPetAdoptPost.length}');
    notifyListeners();
  }


  // This is for multiple search for found pets
  Future <void> startSearchFoundPets(Map<String, dynamic> searchParams) async{

    filterFoundPost = foundPost.where((post) {
      final postFields = {
        'petType': post.petType,
        'petSize': post.petSize,
        'petGender': post.petGender,
        'colorPattern': post.petColor,
        'region': post.petRegion,
        'province': post.petProvince,
        'city': post.petCity,
      };

      // Add breed dynamically based on PetTypeAdopt
      if (post.petType.toLowerCase() == 'dog') {
        postFields['dogBreed'] = post.petBreed;
      } else if (post.petType.toLowerCase() == 'cat') {
        postFields['catBreed'] = post.petBreed;
      }

      final petType = (searchParams['petType'] ?? '').toString().toLowerCase();

      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString().toLowerCase().trim();

        if (value == null || value.isEmpty) continue;

        // Skip wrong breed type
        if ((key == 'dogBreed' && petType != 'dog') || (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue = (postFields[key] ?? '').toString().toLowerCase().trim();

        print('🔎 Comparing "$postValue" with "$value" for key "$key"');

        if (postValue != value) {
          print('❌ Not matched: $key');
          return false;
        }
      }

      return true;
    }).toList();
    print('📦 Filtered posts: ${filterPetAdoptPost.length}');
    notifyListeners();

  }

  // This is for multiple search for missing pets
  Future <void> startSearchMissingPets(Map<String, dynamic> searchParams) async{
    filterMissingPost = missingPost.where((post) {
      final postFields = {
        'petType': post.petType,
        'petSize': post.petSize,
        'petGender': post.petGender,
        'colorPattern': post.petColor,
        'region': post.petRegion,
        'province': post.petProvince,
        'city': post.petCity,
      };

      // Add breed dynamically based on PetTypeAdopt
      if (post.petType.toLowerCase() == 'dog') {
        postFields['dogBreed'] = post.petBreed;
      } else if (post.petType.toLowerCase() == 'cat') {
        postFields['catBreed'] = post.petBreed;
      }

      final petType = (searchParams['petType'] ?? '').toString().toLowerCase();

      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString().toLowerCase().trim();

        if (value == null || value.isEmpty) continue;

        // Skip wrong breed type
        if ((key == 'dogBreed' && petType != 'dog') || (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue = (postFields[key] ?? '').toString().toLowerCase().trim();

        print('🔎 Comparing "$postValue" with "$value" for key "$key"');

        if (postValue != value) {
          print('❌ Not matched: $key');
          return false;
        }
      }

      return true;
    }).toList();

    print('📦 Filtered posts: ${filterPetAdoptPost.length}');
    notifyListeners();
  }

  Future<void> startSearchPetsForRescue(Map<String, dynamic> searchParams) async {
    filterPetForRescuePost = petforRescuePost.where((post) {
      final postFields = {
        'petType': post.rescuePetType,
        'petSize': post.rescuePetSize,
        'petGender': post.rescuePetGender,
        'colorPattern': post.rescuePetColor,
      };

      // Add breed dynamically based on PetTypeAdopt
      if (post.rescuePetType.toLowerCase() == 'dog') {
        postFields['dogBreed'] = post.rescueBreed;
      } else if (post.rescuePetType.toLowerCase() == 'cat') {
        postFields['catBreed'] = post.rescueBreed;
      }

      final petType = (searchParams['petType'] ?? '').toString().toLowerCase();

      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString().toLowerCase().trim();

        if (value == null || value.isEmpty) continue;

        // Skip wrong breed type
        if ((key == 'dogBreed' && petType != 'dog') || (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue = (postFields[key] ?? '').toString().toLowerCase().trim();

        print('🔎 Comparing "$postValue" with "$value" for key "$key"');

        if (postValue != value) {
          print('❌ Not matched: $key');
          return false;
        }
      }

      return true;
    }).toList();

    print('📦 Filtered posts: ${filterPetAdoptPost.length}');

    notifyListeners();
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

  Future <void> startSearchPetCareInsights(Map<String, dynamic> searchParams) async {
    filterVetAndTravelPost = vetAndtravelPost.where((post) {
      final postFields = {
        'region': post.establismentRegion,
        'province': post.establismentProvinces,
        'city': post.establismentCity,
      };


      for (final entry in searchParams.entries) {
        final key = entry.key;
        final value = entry.value?.toString().toLowerCase().trim();

        if (value == null || value.isEmpty) continue;

        final postValue = (postFields[key] ?? '').toString().toLowerCase().trim();

        print('🔎 Comparing "$postValue" with "$value" for key "$key"');

        if (postValue != value) {
          print('❌ Not matched: $key');
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();

  }

  // This will delete the post from the database
  void deletePost(String category, BuildContext context, String postID) async{
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: "Deleting post...");
    try{
      await postRepository.deletePost(category, postID);
    } catch (e) {
      print('Failed to delete post: $e');
    } finally {
      pd.close();
    }

    notifyListeners();
  }

  // load the the pet petOptionsStatus
  Future <void> loadPetStatusOptions(String category) async {

    if(category=='Missing Pets'){
      petStatusOptions = [
        'Still missing',
        'Adopted',
         'Reunited with owner',
      ];

      selectedPetStatus =  'Still missing';
    }
    if (category =='Found Pets'){
      petStatusOptions = [
        'Still roaming',
        'Reunited with owner',
        'Adopted',
      ];

      selectedPetStatus =  'Still roaming';
    }

    if(category =='Pet Adoption'){
      petStatusOptions = [
        'Still up for adoption',
        'Adopted',
      ];

      selectedPetStatus =  'Still up for adoption';
    }

    if(category =='Call for Aid'){
      petStatusOptions = [
        'Ongoing',
        'Paused',
        'Fullfilled',
      ];

      selectedPetStatus =  'Ongoing';
    }
    if(category =='Protect Our Pets: Report Abuse'){

      petStatusOptions = [
        'Will investigate',
        'Ongoing Investigation',
         'Case has been filled',
        'Case has been resolved',
        'Acctions to be taken',
      ];

      selectedPetStatus =  'Will investigate';

    }


    notifyListeners();
  }

  // This will update the post status
  void updatePetStatus(String postId, BuildContext context, String category) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: "Updating post status...");
    try{
      await postRepository.updatePetStatus(postId, category, selectedPetStatus!);
      ToastComponent().showMessage(AppColors.orange, 'Status updated successfully');
    } catch (e) {
      print('Failed to update post status: $e');
    } finally {
      pd.close();
    }

  }

  // This will update the post status
  void setSelectedPetStatus(String? newValue) {

    selectedPetStatus = newValue;
    notifyListeners();

  }

  void navigatoToCreatePost(BuildContext context) async{

    bool isUserVerified = await postRepository.isUserVerified();

     if(!isUserVerified) {
       ToastComponent().showMessage(
           Colors.red, 'Please verify your account to create a post');
       return;
     }

    Navigator.pushNamed(context, AppRoutes.createpost);
    notifyListeners();

  }

}