import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/respository/PostRepository.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../State/InitialLoadingState.dart';
import '../modal/CommentModal.dart';
import '../model/CommentModel.dart';
import '../utils/AppColors.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import '../utils/ToastComponent.dart';

class PostViewModel extends ChangeNotifier {
  final searchPostController = TextEditingController();
  String role = '';
  String currentUserId = '';
  bool _isSearching = false;

  bool get isSearching => _isSearching;
  Timer? _debounce;

  bool _isInitialLoading = false;

  bool get isInitialLoading => _isInitialLoading;

  // globally hold subscription post on every tab.
  StreamSubscription? _postSubscription;
  StreamSubscription? _posSubscription;
  StreamSubscription? _missingPostSubscription;
  StreamSubscription? _foundPostSubscription;
  StreamSubscription? _pawExperiencePostSubscription;
  StreamSubscription? _protectedPostSubscription;
  StreamSubscription? _communityPostSubscription;
  StreamSubscription? _vetAndTravelPostSubscription;
  StreamSubscription? _petAdoptPostSubscription;
  StreamSubscription? _callforAidPostSubscription;
  StreamSubscription? _petforRescuePostSubscription;
  StreamSubscription? _myPostSubscription;
  StreamSubscription<String>? _statusSubscription;

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

  Stream<List<PostModel>> get missingPostStream =>
      postRepository.getMissingPosts();

  Stream<List<PostModel>> get foundPostStream => postRepository.getFoundPost();

  Stream<List<PostModel>> get pawExperiencePostStream =>
      postRepository.getPawExperiencePost();

  Stream<List<PostModel>> get protectedPostStream =>
      postRepository.getProtectPetPost();

  Stream<List<PostModel>> get communityPostStream =>
      postRepository.getCommunityPost();

  Stream<List<PostModel>> get vetAndTravelPostStream =>
      postRepository.getVetAndTravelPost();

  Stream<List<PostModel>> get petAdoptPostStream =>
      postRepository.getPetAdoption();

  Stream<List<PostModel>> get callforAidPostStream =>
      postRepository.getCallforAid();

  Stream<List<PostModel>> get petForRescue => postRepository.getFindHome();

  Stream<List<PostModel>> get myPostStream => postRepository.getMyPost();

  List<String> petStatusOptions = [];
  String? selectedPetStatus;
  Stream<String> retrievePetStatus = const Stream.empty();

  final PostRepositoryImpl postRepositoryImpl = PostRepositoryImpl();

  final Map<String, PostCategoryState> _categoryStates = {};

  List<PostModel> get petForRescuePosts =>
      _categoryStates['Pets For Rescue']?.filteredPosts ?? [];

  bool get isPetForRescueLoading =>
      _categoryStates['Pets For Rescue']?.isLoading ?? true;

  List<PostModel> get petFoundsPosts =>
      _categoryStates['Found Pets']?.filteredPosts ?? [];

  bool get isPetFoundsLoading =>
      _categoryStates['Found Pets']?.isLoading ?? true;

  List<PostModel> get petMissingPosts =>
      _categoryStates['Missing Pets']?.filteredPosts ?? [];

  bool get isPetMissingLoading =>
      _categoryStates['Missing Pets']?.isLoading ?? true;

// Add more here
  List<PostModel> get petAppreciationPosts =>
      _categoryStates['Pet Appreciation']?.filteredPosts ?? [];

  bool get isPetAppreciationLoading =>
      _categoryStates['Pet Appreciation']?.isLoading ?? true;

  List<PostModel> get pawsomeExperiencePosts =>
      _categoryStates['Paw-some Experience']?.filteredPosts ?? [];

  bool get isPawsomeExperienceLoading =>
      _categoryStates['Paw-some Experience']?.isLoading ?? true;

  List<PostModel> get protectOurPetsPosts =>
      _categoryStates['Protect Our Pets: Report Abuse']?.filteredPosts ?? [];

  bool get isProtectOurPetsLoading =>
      _categoryStates['Protect Our Pets: Report Abuse']?.isLoading ?? true;

  List<PostModel> get communityAnnouncementsPosts =>
      _categoryStates['Community Announcements']?.filteredPosts ?? [];

  bool get isCommunityAnnouncementsLoading =>
      _categoryStates['Community Announcements']?.isLoading ?? true;

  List<PostModel> get petAdoptionPosts =>
      _categoryStates['Pet Adoption']?.filteredPosts ?? [];

  bool get isPetAdoptionLoading =>
      _categoryStates['Pet Adoption']?.isLoading ?? true;

  List<PostModel> get petCareInsightsPosts =>
      _categoryStates['Pet Care Insights']?.filteredPosts ?? [];

  bool get isPetCareInsightsLoading =>
      _categoryStates['Pet Care Insights']?.isLoading ?? true;

  List<PostModel> get callForAidPosts =>
      _categoryStates['Call for Aid']?.filteredPosts ?? [];

  bool get isCallForAidLoading =>
      _categoryStates['Call for Aid']?.isLoading ?? true;

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

  void initializeAllListeners() {
    listenToCategoryStream('Pets For Rescue', petForRescue);
    listenToCategoryStream('Found Pets', foundPostStream);
    listenToCategoryStream('Missing Pets', missingPostStream);
    listenToCategoryStream('Pet Appreciation', posTream);
    listenToCategoryStream('Paw-some Experience', pawExperiencePostStream);
    listenToCategoryStream(
        'Protect Our Pets: Report Abuse', protectedPostStream);
    listenToCategoryStream('Community Announcements', communityPostStream);
    listenToCategoryStream('Pet Adoption', petAdoptPostStream);
    listenToCategoryStream('Pet Care Insights', vetAndTravelPostStream);
    listenToCategoryStream('Call for Aid', callforAidPostStream);
  }

  Future<void> listenToCategoryStream(
      String category, Stream<List<PostModel>> stream) async {
    // Get the current state for this category, or create a new one
    final state =
        _categoryStates.putIfAbsent(category, () => PostCategoryState());

    // Set loading state *for this specific category*
    state.isLoading = true;
    print(
        "📡 Starting to listen to the '$category' stream..."); // <-- ADDED LOG
    notifyListeners();

    // Cancel any previous subscription for this category
    await state.subscription?.cancel();

    // Clear previous data
    state.posts.clear();
    state.filteredPosts.clear();

    // Listen to the new stream
    state.subscription = stream.listen(
      (postList) {
        // This is the success case
        print(
            '✅ Received ${postList.length} posts for category: $category'); // <-- EXISTING LOG

        for (var post in postList) {
          post.initializeStreams(onUpdate: notifyListeners);
        }

        // Update the lists within the state object
        state.posts = postList;
        state.filteredPosts =
            postList; // Initially, filtered list is the full list

        // Turn off loading for this category
        state.isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        // This handles any errors from the stream
        print("❌ Error on '$category' stream: $error"); // <-- ADDED LOG
        state.isLoading = false;
        notifyListeners();
      },
      onDone: () {
        // This is called when the stream is closed
        print("🏁 Stream for '$category' is done."); // <-- ADDED LOG
      },
    );
  }

  // initialize role and current user id
  Future<void> loadData() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        currentUserId = user.uid;

        final sessionManager = SessionManager();
        final userData = await sessionManager.getUserInfo();

        role = userData?['role'] ?? '';
        notifyListeners();
      } else {
        // Handle logout case
        currentUserId = '';
        role = '';
        notifyListeners();
      }
    });
  }

// debounce realtime logic < BUG FIXED CLIENT LAG WRONG RESULTS ON SEARCH >
  void onSearchChanged(String category, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call the single, generic search function for the correct category
      searchPostGlobalCategory(category, query);
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
  Future<void> addReaction(String postId, String reaction) async {
    try {
      await postRepository.addReaction(postId, reaction);
    } catch (e) {
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

  Future<void> editComment(
      String postId, String commentId, String newCommentText) async {
    try {
      await postRepository.editComment(postId, commentId, newCommentText);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to edit comment: $e');
    }
  }

  // Listen to protected post < BUG FIXED CLIENT LAG>
  Future<void> listenToProtectedPost() async {
    _isInitialLoading = true;
    notifyListeners();

    // avoid memory leaks
    await _postSubscription?.cancel();

    protectedPost.clear();
    filterProtectedPost.clear();
    _postSubscription = protectedPostStream.listen((protectedPosts) {
      protectedPost = protectedPosts;
      filterProtectedPost = protectedPosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

  Future<void> listenToPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _posSubscription?.cancel();

    _posts.clear();
    filteredPost.clear();

    _posSubscription = posTream.listen((posts) {
      _posts = posts;
      filteredPost = posts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

  // Listen to missing post
  Future<void> listenToMissingPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _missingPostSubscription?.cancel();

    missingPost.clear();
    filterMissingPost.clear();

    _missingPostSubscription = missingPostStream.listen((missingPosts) {
      missingPost = missingPosts;
      filterMissingPost = missingPosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

  // Listen to found post
  Future<void> listenToFoundPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _foundPostSubscription?.cancel();

    foundPost.clear();
    filterFoundPost.clear();

    _foundPostSubscription = foundPostStream.listen((foundPosts) {
      foundPost = foundPosts;
      filterFoundPost = foundPosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

  // Listen to paw experience post
  Future<void> listenToPawExperiencePost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _pawExperiencePostSubscription?.cancel();

    pawExperiencePost.clear();
    filterPawExperiencePost.clear();

    _pawExperiencePostSubscription =
        pawExperiencePostStream.listen((pawExperiencePosts) {
      pawExperiencePost = pawExperiencePosts;
      filterPawExperiencePost = pawExperiencePosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

  // Listen to community post
  Future<void> listenToCommunityPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _communityPostSubscription?.cancel();

    communityPost.clear();
    filterCommunityPost.clear();
    print('############################################################');
    print('############      CURRENT ROLE: $role      ############');
    print('############################################################');

    _communityPostSubscription = communityPostStream.listen((communityPosts) {
      communityPost = communityPosts;
      filterCommunityPost = communityPosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

// Listen to vet and travel post
  Future<void> listenToVetAndTravelPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _vetAndTravelPostSubscription?.cancel();

    vetAndtravelPost.clear();
    filterVetAndTravelPost.clear();

    _vetAndTravelPostSubscription =
        vetAndTravelPostStream.listen((travelPosts) {
      vetAndtravelPost = travelPosts;
      filterVetAndTravelPost = travelPosts;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

// Listen to pet adopt post
  Future<void> listenToPetAdoptPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _petAdoptPostSubscription?.cancel();

    petAdoptPost.clear();
    filterPetAdoptPost.clear();

    _petAdoptPostSubscription = petAdoptPostStream.listen((adoptpost) {
      petAdoptPost = adoptpost;
      filterPetAdoptPost = adoptpost;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

// Listen to call for aid post
  Future<void> listenToCallforAidPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _callforAidPostSubscription?.cancel();

    callforAidPost.clear();
    filterCallforAidPost.clear();

    _callforAidPostSubscription = callforAidPostStream.listen((aidPost) {
      callforAidPost = aidPost;
      filterCallforAidPost = aidPost;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

// Listen to pet for rescue post
  Future<void> listenToPetForRescuePost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _petforRescuePostSubscription?.cancel();

    petforRescuePost.clear();
    filterPetForRescuePost.clear();

    _petforRescuePostSubscription = petForRescue.listen((rescuePost) {
      petforRescuePost = rescuePost;
      filterPetForRescuePost = rescuePost;

      if (_isInitialLoading) {
        _isInitialLoading = false;
      }
      notifyListeners();
    });
  }

// Listen to my post
  Future<void> listenToMyPost() async {
    _isInitialLoading = true;
    notifyListeners();

    await _myPostSubscription?.cancel();

    myPostlist.clear();
    filterMyPost.clear();

    _myPostSubscription = myPostStream.listen(
      (myPosts) {
        myPostlist = myPosts;
        filterMyPost = myPosts;

        if (_isInitialLoading) {
          _isInitialLoading = false;
        }
        notifyListeners();
      },
      onError: (error) {
        print('Error listening to myPost stream: $error');
        if (_isInitialLoading) {
          _isInitialLoading = false;
        }
        notifyListeners();
      },
    );
  }

  // search post global
  void searchPostGlobalCategory(String category, String query) {
    // 1. Get the state object for the specific category
    final state = _categoryStates[category];
    if (state == null) return; // Exit if the category doesn't exist

    // 2. If the search query is empty, reset the filtered list to the original full list
    if (query.isEmpty) {
      state.filteredPosts = state.posts;
    } else {
      final lowerCaseQuery = query.toLowerCase();
      // 3. Otherwise, filter the original 'posts' list and update 'filteredPosts'
      state.filteredPosts = state.posts
          .where((post) =>
              // Check if any tag name contains the query
              post.tags.any(
                  (tag) => tag.name.toLowerCase().contains(lowerCaseQuery)) ||

              // Check if the post owner's name contains the query
              post.postOwnerName.toLowerCase().contains(lowerCaseQuery) ||

              // --- ADDED SEARCH CONDITIONS ---
              // Check the pet name (for missing/found posts, etc.)
              post.petName.toLowerCase().contains(lowerCaseQuery) ||

              // Check the pet adoption name
              post.petNameAdopt.toLowerCase().contains(lowerCaseQuery) ||

              // Check the establishment/clinic name
              post.establisHment_Clinic_Name
                  .toLowerCase()
                  .contains(lowerCaseQuery) ||

              // Check the main post description
              post.postDescription.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
    notifyListeners(); // Don't forget to notify listeners to update the UI
  }

  void searchPost(String search) {
    if (search.isEmpty) {
      filteredPost = _posts;
    } else {
      filteredPost = _posts
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(search.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(search))
          .toList();
    }
    notifyListeners();
  }

  // Missing Post
  Future<void> searchMissingPost(String searchText) async {
    _isSearching = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));

    final lowercasedSearchText = searchText.toLowerCase();

    if (lowercasedSearchText.isEmpty) {
      filterMissingPost = missingPost;
    } else {
      filterMissingPost = missingPost.where((post) {
        return post.petName.toLowerCase().contains(lowercasedSearchText) ||
            post.postOwnerName.toLowerCase().contains(lowercasedSearchText) ||
            post.petType.toLowerCase().contains(lowercasedSearchText) ||
            post.petBreed.toLowerCase().contains(lowercasedSearchText) ||
            post.petGender.toLowerCase().contains(lowercasedSearchText) ||
            post.petAge.toLowerCase().contains(lowercasedSearchText) ||
            post.petColor.toLowerCase().contains(lowercasedSearchText) ||
            post.petAddress.toLowerCase().contains(lowercasedSearchText) ||
            post.petCollar.toLowerCase().contains(lowercasedSearchText) ||
            post.regProCiBag.toLowerCase().contains(lowercasedSearchText) ||
            post.date.toLowerCase().contains(lowercasedSearchText) ||
            post.petSize.toLowerCase().contains(lowercasedSearchText);
      }).toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Found Post
  void searchFoundPost(String searchText) {
    if (searchText.isEmpty) {
      filterFoundPost = foundPost;
    } else {
      filterFoundPost = foundPost
          .where((post) =>
              post.petName.toLowerCase().contains(searchText.toLowerCase()) ||
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.petType.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petBreed.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petGender.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petAge.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petColor.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petAddress
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petCollar.toLowerCase().contains(searchText.toLowerCase()) ||
              post.regProCiBag
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.date.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petSize.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petType.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Paw Experience Post
  void searchPawExperience(String search) {
    if (search.isEmpty) {
      filterPawExperiencePost = pawExperiencePost;
    } else {
      filterPawExperiencePost = pawExperiencePost
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(search.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(search))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Protected Post
  void searchProtectedPost(String search) {
    if (search.isEmpty) {
      filterProtectedPost = List.from(protectedPost);
    } else {
      filterProtectedPost = protectedPost
          .where((post) => post.tags.any(
              (tag) => tag.name.toLowerCase().contains(search.toLowerCase())))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Community Post
  void searchCommunityPost(String search) {
    if (search.isEmpty) {
      filterCommunityPost.addAll(communityPost);
    } else {
      filterCommunityPost.addAll(communityPost
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(search.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(search))
          .toList());
    }
    _isSearching = false;
    notifyListeners();
  }

  // Vet and Travel Post
  void searchVetAndTravelPost(String search) {
    if (search.isEmpty) {
      filterVetAndTravelPost = vetAndtravelPost;
    } else {
      filterVetAndTravelPost = vetAndtravelPost
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(search.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(search))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Pet Adopt Post
  void searchPetAdoptPost(String search) {
    if (search.isEmpty) {
      filterPetAdoptPost = petAdoptPost;
    } else {
      filterPetAdoptPost = petAdoptPost
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(search.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(search) ||
              post.petNameAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petBreedAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petAgeAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petGenderAdopt
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              post.petColorAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petSizeAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petAddressAdopt
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              post.regProCiBagAdopt
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              post.dateAdopt.toLowerCase().contains(search.toLowerCase()) ||
              post.petTypeAdopt.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Search PawSome Post
  void searchPawSome(String searchText) {
    if (searchText.isEmpty) {
      filterPawExperiencePost = pawExperiencePost;
    } else {
      filterPawExperiencePost = pawExperiencePost
          .where((post) =>
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(searchText.toLowerCase())))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Search Call for Aid Post
  void searchCallforAidPost(String searchText) {
    if (searchText.isEmpty) {
      filterCallforAidPost = callforAidPost;
    } else {
      filterCallforAidPost = callforAidPost
          .where((post) =>
              post.bankHolder
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
              post.postDescription
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.accountNumber
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.estimatedAmount
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.donationType
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.donationType
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.statusDonation
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // Search Pet for Rescue Post
  void searchPetForRescue(String searchText) {
    if (searchText.isEmpty) {
      filterPetForRescuePost = petforRescuePost;
    } else {
      filterPetForRescuePost = petforRescuePost
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.rescuePetSize
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescueStatus
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescueAddress
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescuePetColor
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescueBreed
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petType.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
  }

  // This will search user post
  void searchMyPost(String searchText) {
    if (searchText.isEmpty) {
      filterMyPost = myPostlist;
    } else {
      filterMyPost = myPostlist
          .where((post) =>
              post.tags.any((tag) =>
                  tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.rescuePetSize
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescueStatus
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescueAddress
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.rescuePetColor
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.establisHment_Clinic_Name
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.establismentRegion
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.establismentProvinces
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.establismentCity
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petNameAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petBreedAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petAgeAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petGenderAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petColorAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petSizeAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.petAddressAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.regProCiBagAdopt
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              post.dateAdopt.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petTypeAdopt.toLowerCase().contains(searchText.toLowerCase()) ||
              post.bankHolder.toLowerCase().contains(searchText.toLowerCase()) ||
              post.accountNumber.toLowerCase().contains(searchText.toLowerCase()) ||
              post.estimatedAmount.toLowerCase().contains(searchText.toLowerCase()) ||
              post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||
              post.donationType.toLowerCase().contains(searchText.toLowerCase()) ||
              post.statusDonation.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petName.toLowerCase().contains(searchText.toLowerCase()) ||
              post.postOwnerName.toLowerCase().contains(searchText) ||
              post.tags.any((tag) => tag.name.toLowerCase().contains(searchText.toLowerCase())) ||
              post.postDescription.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petType.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petBreed.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petGender.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petAge.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petColor.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petAddress.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petCollar.toLowerCase().contains(searchText.toLowerCase()) ||
              post.rescueBreed.toLowerCase().contains(searchText.toLowerCase()) ||
              post.petType.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    _isSearching = false;
    notifyListeners();
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
        if ((key == 'dogBreed' && petType != 'dog') ||
            (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue =
            (postFields[key] ?? '').toString().toLowerCase().trim();

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
  Future<void> startSearchFoundPets(Map<String, dynamic> searchParams) async {
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
        if ((key == 'dogBreed' && petType != 'dog') ||
            (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue =
            (postFields[key] ?? '').toString().toLowerCase().trim();

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
  Future<void> startSearchMissingPets(Map<String, dynamic> searchParams) async {
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
        if ((key == 'dogBreed' && petType != 'dog') ||
            (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue =
            (postFields[key] ?? '').toString().toLowerCase().trim();

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

  Future<void> startSearchPetsForRescue(
      Map<String, dynamic> searchParams) async {
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
        if ((key == 'dogBreed' && petType != 'dog') ||
            (key == 'catBreed' && petType != 'cat')) {
          continue;
        }

        final postValue =
            (postFields[key] ?? '').toString().toLowerCase().trim();

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

  Future<void> startSearchPetCareInsights(
      Map<String, dynamic> searchParams) async {
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

        final postValue =
            (postFields[key] ?? '').toString().toLowerCase().trim();

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
  void deletePost(String category, BuildContext context, String postID) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: "Deleting post...");
    try {
      // 1. Delete the post from the Firestore database
      await postRepository.deletePost(category, postID);

      // 2. Remove the post from the correct local list based on its category
      // This provides the instantaneous UI update.
      switch (category) {
        case 'Protect Our Pets: Report Abuse':
          protectedPost.removeWhere((post) => post.postId == postID);
          filterProtectedPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Missing Pets':
          missingPost.removeWhere((post) => post.postId == postID);
          filterMissingPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Found Pets':
          foundPost.removeWhere((post) => post.postId == postID);
          filterFoundPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Pet for Adoption':
          petAdoptPost.removeWhere((post) => post.postId == postID);
          filterPetAdoptPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Pet for Rescue':
          petforRescuePost.removeWhere((post) => post.postId == postID);
          filterPetForRescuePost.removeWhere((post) => post.postId == postID);
          break;
        case 'Call for Aid':
          callforAidPost.removeWhere((post) => post.postId == postID);
          filterCallforAidPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Pet Care Insights':
          vetAndtravelPost.removeWhere((post) => post.postId == postID);
          filterVetAndTravelPost.removeWhere((post) => post.postId == postID);
          break;
        case 'Paw-some Moments':
          pawExperiencePost.removeWhere((post) => post.postId == postID);
          filterPawExperiencePost.removeWhere((post) => post.postId == postID);
          break;
        case 'Community Announcements':
          communityPost.removeWhere((post) => post.postId == postID);
          filterCommunityPost.removeWhere((post) => post.postId == postID);
          break;
        // This covers the generic 'Pet Appreciation' and other posts
        default:
          _posts.removeWhere((post) => post.postId == postID);
          filteredPost.removeWhere((post) => post.postId == postID);
      }

      // 3. Notify listeners to rebuild the UI with the updated list
      notifyListeners();

      ToastComponent().showMessage(Colors.green, 'Post Deleted Successfully');
    } catch (e) {
      print('Failed to delete post: $e');
      ToastComponent().showMessage(Colors.red, 'Failed to delete post');
    } finally {
      // 4. Close the progress dialog
      pd.close();
    }
  }

  // load the the pet petOptionsStatus
  Future<void> loadPetStatusOptions(String category, String postId) async {
    //====== BIGGEST PRINT SHOWING CATEGORY ======//
    print('############################################################');
    print('############   CURRENT CATEGORY: $category   ############');
    print('############################################################');
    //==============================================//

    _statusSubscription?.cancel();

    if (category == 'Missing Pets') {
      petStatusOptions = ['Still missing', 'Adopted', 'Reunited with owner'];
    } else if (category == 'Found Pets') {
      petStatusOptions = ['Still roaming', 'Reunited with owner', 'Adopted'];
    } else if (category == 'Pet Adoption') {
      petStatusOptions = ['Still up for adoption', 'Adopted'];
    } else if (category == 'Call for Aid') {
      petStatusOptions = [
        'Ongoing',
        'Paused',
        'Fulfilled'
      ]; // Corrected spelling
    } else if (category == 'Protect Our Pets: Report Abuse') {
      petStatusOptions = [
        'Will investigate',
        'Ongoing Investigation',
        'Case has been filled',
        'Case has been resolved',
        'Actions to be taken'
      ]; // Corrected spelling
    } else if (category == 'Pets For Rescue') {
      petStatusOptions = [
        'Still roaming',
        'Still needing rescue',
        'Rescued',
        'For Adoption'
      ];
    } else {
      petStatusOptions = [];
    }

    Stream<String> retrievePetStatus =
        postRepository.getStatus(postId, category);

    _statusSubscription = retrievePetStatus.listen((status) {
      selectedPetStatus = status;
      notifyListeners();
    });
  }

  Future<bool> updatePetStatus(
      String postId, BuildContext context, String category) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: "Updating post status...");
    try {
      await postRepository.updatePetStatus(
          postId, category, selectedPetStatus!);

      ToastComponent()
          .showMessage(AppColors.orange, 'Status updated successfully');

      pd.close(); // Close dialog on success
      return true; // Return true when the update is successful
    } catch (e) {
      print('Failed to update post status: $e');
      ToastComponent().showMessage(
          Colors.red, 'Failed to update status'); // Optional error toast

      pd.close(); // Close dialog on failure
      return false; // Return false when an error occurs
    }
  }

  // This will update the post status
  void setSelectedPetStatus(String? newValue) {
    selectedPetStatus = newValue;
    notifyListeners();
  }

  void navigatoToCreatePost(BuildContext context) async {
    bool isUserVerified = await postRepository.isUserVerified();

    if (!isUserVerified) {
      ToastComponent().showMessage(
          Colors.red, 'Please verify your account to create a post');

      Fluttertoast.showToast(
        msg: "Please verify your account to create a post",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.createpost);
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the timer if it's active
    _postSubscription?.cancel();
    _missingPostSubscription?.cancel();
    _foundPostSubscription?.cancel();
    _pawExperiencePostSubscription?.cancel();
    _protectedPostSubscription?.cancel();
    _communityPostSubscription?.cancel();
    _vetAndTravelPostSubscription?.cancel();
    _petAdoptPostSubscription?.cancel();
    _callforAidPostSubscription?.cancel();
    _petforRescuePostSubscription?.cancel();
    _myPostSubscription?.cancel();
    searchPostController.dispose();
    _statusSubscription?.cancel();
    currentUserId = '';
    role = '';
    super.dispose();
  }
}
