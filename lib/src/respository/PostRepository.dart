import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../model/CommentModel.dart';
import '../utils/AppColors.dart';
import 'dart:developer' as developer;

abstract class PostRepository {
  Future<void> uploadPost(String postText, List<File> images, String category);
  Stream<List<PostModel>> getPosts();

  Future <void> uploadPetData(List<File> images, String selectedChip, Map<String, dynamic> petData);

  Future <void> addReaction(String postId, String reaction);

  Future<bool> hasUserReacted(String postId);

  Future<int> getReactionCount(String postId);

  Future<void> removeReaction(String postId);

  Future<String?> getUserReaction(String postId);

  Future<void> addComment(String postId, String commentText);

  Stream<List<CommentModel>> getComments(String postId);

  Future <void> deleteComment(String postId, String commentId);

  Future<int> getCommentCount(String postId);

  Stream<List<PostModel>>getMissingPosts();

  Stream<List<PostModel>>getFoundPost();

  Stream<List<PostModel>>getPawExperiencePost();

  Stream<List<PostModel>>getProtectPetPost();

  Stream<List<PostModel>>getCommunityPost();

  Stream<List<PostModel>> getVetAndTravelPost();

  Stream<List<PostModel>> getCallforAid();

  Future <void> editComment(String postId, String commentId, String newCommentText);

  Future <void> uploadAdoption(List<File> images, String selectedChip, Map<String, dynamic> petData);

  Stream<List<PostModel>> getPetAdoption();

  Future<List<PostModel>> getNearbyFoundPets(double lat, double long, double radiusInK);

  Future<List<PostModel>> getNearbyLostPets(double lat, double long, double radiusInK);

  Future <void> uploadDonation(List<File> images, String selectedChip, Map<String, dynamic> petData);

}

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> uploadPost(String postText, List<File> images, String category) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();
    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(postID);
      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': postText,
        'Category': category,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created $category post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      // Upload images concurrently and store their URLs in the images sub-collection
      List<Future<void>> uploadTasks = images.map((File image) async {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _firebaseStorage.ref().child('PostFolder/$postID/$fileName.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add image URL to the images sub-collection
        await postRef.collection('ImageCollection').add({
          'FileUrl': downloadUrl,
          'FileName': '$fileName.jpg',
        });
      }).toList();

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Added get post
  @override
  Stream<List<PostModel>> getPosts() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Pet Appreciation')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added upload pet data
  @override
  Future<void> uploadPetData(List<File> images, String selectedChip, Map<String, dynamic> petData) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();

    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(postID);

      String post = petData['post'];
      String petName = petData['pet_name'];
      String petType = petData['pet_type'];
      String petBreed = petData['pet_breed'];
      String petAge = petData['pet_age'];
      String region = petData['region'];
      String province = petData['province'];
      String city = petData['city'];
      String gender = petData['gender'];
      String size = petData['size'];
      String color = petData['color'];
      String collar = petData['collar'];
      String barangay = petData['barangay'];
      String address = petData['address'];
      double lat = petData['lat'];
      double long = petData['long'];
      String date = petData['date'];

      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      // Create a new document in PetDetailsCollection
      DocumentReference petRef = _firestore.collection('PetDetailsCollection').doc(postID);
      await petRef.set({
        'PetName': petName,
        'PetType': petType,
        'PetGender': gender,
        'PetSize': size,
        'PetColor': color,
        'PetCollar': collar,
        'PetBreed': petBreed,
        'PetAge': petAge,
        'Region': region,
        'Province': province,
        'City': city,
        'Barangay': barangay,
        'Address': address,
        'Latitude': lat,
        'Date': date,
        'Longitude': long,
        'Status': selectedChip == 'Missing Pets' ? 'Still missing' : 'Still roaming',
      });

      ToastComponent().showMessage(AppColors.orange, '$selectedChip data added successfully');

      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created $selectedChip post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'A user has created a $selectedChip post',
        'notifiedTo': 'Pet Rescuer',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      // Upload images concurrently and store their URLs in the images sub-collection
      List<Future<void>> uploadTasks = images.map((File image) async {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _firebaseStorage.ref().child('PostFolder/$postID/$fileName.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add image URL to the images sub-collection
        await postRef.collection('ImageCollection').add({
          'FileUrl': downloadUrl,
          'FileName': '$fileName.jpg',
        });
      }).toList();

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Added upload pet data
  @override
  Future<void> uploadAdoption(List<File> images, String selectedChip, Map<String, dynamic> petData) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();

    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(postID);

      String post = petData['post'];
      String petName = petData['pet_name'];
      String petType = petData['pet_type'];
      String petBreed = petData['pet_breed'];
      String petAge = petData['pet_age'];
      String region = petData['region'];
      String province = petData['province'];
      String city = petData['city'];
      String gender = petData['gender'];
      String size = petData['size'];
      String color = petData['color'];
      String barangay = petData['barangay'];
      String address = petData['address'];

      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      // Create a new document in PetDetailsCollection
      DocumentReference petRef = _firestore.collection('AdoptionDetails').doc(postID);
      await petRef.set({
        'PetName': petName,
        'PetType': petType,
        'PetGender': gender,
        'PetSize': size,
        'Category': selectedChip,
        'PetColor': color,
        'PetBreed': petBreed,
        'PetAge': petAge,
        'Region': region,
        'Province': province,
        'City': city,
        'Barangay': barangay,
        'Address': address,
        'Status': 'Still up for adoption',
      });

      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created a Adoption post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      ToastComponent().showMessage(AppColors.orange, '$selectedChip data added successfully');

      // Upload images concurrently and store their URLs in the images sub-collection
      List<Future<void>> uploadTasks = images.map((File image) async {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _firebaseStorage.ref().child('PostFolder/$postID/$fileName.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add image URL to the images sub-collection
        await postRef.collection('ImageCollection').add({
          'FileUrl': downloadUrl,
          'FileName': '$fileName.jpg',
        });
      }).toList();

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Added reaction functions
  @override
  Future<void> addReaction(String postId, String reaction) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    try {
      // Reference to the reaction document
      DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);

      // Check if the user has already reacted
      DocumentSnapshot reactionSnapshot = await reactionRef.get();

      if (reactionSnapshot.exists) {
        // Update the existing reaction
        await reactionRef.update({
          'Reaction': reaction,
          'Timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Add a new reaction
        await reactionRef.set({
          'Reaction': reaction,
          'Timestamp': FieldValue.serverTimestamp(),
        });
      }

      ToastComponent().showMessage(AppColors.orange, 'Reaction added successfully');
    } catch (e) {
      throw Exception('Failed to add reaction: $e');
    }
  }

  // Added has user reacted function
  @override
  Future<bool> hasUserReacted(String postId) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);
    DocumentSnapshot reactionSnapshot = await reactionRef.get();

    return reactionSnapshot.exists;
  }

  // Added get reaction count function
  @override
  Future<int> getReactionCount(String postId) async {
    QuerySnapshot reactionSnapshot = await _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').get();
    return reactionSnapshot.docs.length;
  }

  // Added remove reaction function
  @override
  Future<void> removeReaction(String postId) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);
    await reactionRef.delete();
  }

  // Added get user reaction function
  @override
  Future<String?> getUserReaction(String postId) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);
    DocumentSnapshot reactionSnapshot = await reactionRef.get();

    if (reactionSnapshot.exists) {
      return reactionSnapshot['Reaction'];
    } else {
      return null;
    }
  }

  // Added get comment count function
  Future<int> getCommentCount(String postId) async {
    QuerySnapshot commentSnapshot = await _firestore.collection('PostCollection').doc(postId).collection('CommentCollection').get();
    return commentSnapshot.docs.length;
  }

  // Added add comment function
  Future<void> addComment(String postId, String commentText) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference userRef = _firestore.collection('Users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      throw Exception('User not found');
    }

    DocumentReference commentRef = _firestore.collection('PostCollection').doc(postId).collection('CommentCollection').doc();

    await commentRef.set({
      'UserId': userId,
      'CommentText': commentText,
      'Timestamp': FieldValue.serverTimestamp(),
    });

    ToastComponent().showMessage(AppColors.orange, 'Comment added successfully');
  }
  // Added get comments function
  @override
  Stream<List<CommentModel>> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('PostCollection')
        .doc(postId)
        .collection('CommentCollection')
        .orderBy('Timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<CommentModel>> commentFutures = snapshot.docs.map((doc) => CommentModel.fromDocument(doc)).toList();
      return await Future.wait(commentFutures);
    });
  }

  // Added delete comment function
  @override
  Future<void> deleteComment(String postId, String commentId) async{
    return await _firestore.collection('PostCollection').doc(postId).collection('CommentCollection').doc(commentId).delete();
  }


  // Added edit comment function
  Future<void> editComment(String postId, String commentId, String newCommentText) async {
    return await _firestore.collection('PostCollection').doc(postId).collection('CommentCollection').doc(commentId).update({
      'CommentText': newCommentText,
    });
  }

  // Added get missing posts function
  @override
  Stream<List<PostModel>> getMissingPosts() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Missing Pets')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added get found post
  @override
  Stream<List<PostModel>> getFoundPost() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Found Pets')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added get paw experience post
  @override
  Stream<List<PostModel>> getPawExperiencePost() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Paw-some Experience')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added get protect pet post
  @override
  Stream<List<PostModel>> getProtectPetPost() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Protect Our Pets: Report Abuse')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added get community post
  @override
  Stream<List<PostModel>> getCommunityPost() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Community Announcement')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // Added get community post
  @override
  Stream<List<PostModel>> getVetAndTravelPost() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Caring for Pets: Vet & Travel Insights')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // get the pet adoption
  @override
  Stream<List<PostModel>> getPetAdoption() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Pet Adoption')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // get the call for aid
  @override
  Stream<List<PostModel>> getCallforAid() {
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Call for Aid')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // get the nearby found pets
  Future<List<PostModel>> getNearbyFoundPets(double lat, double long, double radiusInK) async {
    try {
      // Define the radius in kilometers
      double radiusInKm = radiusInK;

      // Calculate the bounds for the query
      double latDelta = radiusInKm / 111.0; // 1 degree of latitude is approximately 111 km
      double longDelta = radiusInKm / (111.0 * cos(lat * pi / 180.0));

      // Query Firestore for found pets within the bounds in PostCollection
      QuerySnapshot postCollectionSnapshot = await _firestore.collection('PostCollection')
          .where('Category', isEqualTo: 'Found Pets').get();

      // For each post, query the PetDetailsCollection to get the corresponding pet details
      List<PostModel> foundPets = await Future.wait(postCollectionSnapshot.docs.map((doc) async {
        var post = await PostModel.fromDocument(doc);
        var petDetailsSnapshot = await _firestore.collection('PetDetailsCollection')
            .where('Category', isEqualTo: 'Found Pets')
            .where('Latitude', isGreaterThanOrEqualTo: lat - latDelta)
            .where('Latitude', isLessThanOrEqualTo: lat + latDelta)
            .where('Longitude', isGreaterThanOrEqualTo: long - longDelta)
            .where('Longitude', isLessThanOrEqualTo: long + longDelta)
            .get();

        if (petDetailsSnapshot.docs.isNotEmpty) {
          var petDetailsDoc = petDetailsSnapshot.docs.first;
          post.lat = petDetailsDoc['Latitude'];
          post.long = petDetailsDoc['Longitude'];
        }
        return post;
      }).toList());

      return foundPets;
    } catch (e) {
      developer.log('Error fetching nearby found pets: $e');
      return [];
    }
  }

  // get the nearby lost pets
  @override
  Future<List<PostModel>> getNearbyLostPets(double lat, double long, double radiusInK) async{
    try {
      // Define the radius in kilometers
      double radiusInKm = radiusInK;

      // Calculate the bounds for the query
      double latDelta = radiusInKm / 111.0; // 1 degree of latitude is approximately 111 km
      double longDelta = radiusInKm / (111.0 * cos(lat * pi / 180.0));

      // Query Firestore for found pets within the bounds in PostCollection
      QuerySnapshot missingCollectionSnapshot = await _firestore.collection('PostCollection')
          .where('Category', isEqualTo: 'Missing Pets').get();

      // For each post, query the PetDetailsCollection to get the corresponding pet details
      List<PostModel> missingpets = await Future.wait(missingCollectionSnapshot.docs.map((doc) async {
        var post = await PostModel.fromDocument(doc);
        var petDetailsSnapshot = await _firestore.collection('PetDetailsCollection')
            .where('Category', isEqualTo: 'Missing Pets')
            .where('Latitude', isGreaterThanOrEqualTo: lat - latDelta)
            .where('Latitude', isLessThanOrEqualTo: lat + latDelta)
            .where('Longitude', isGreaterThanOrEqualTo: long - longDelta)
            .where('Longitude', isLessThanOrEqualTo: long + longDelta)
            .get();

        if (petDetailsSnapshot.docs.isNotEmpty) {
          var petDetailsDoc = petDetailsSnapshot.docs.first;
          post.lat = petDetailsDoc['Latitude'];
          post.long = petDetailsDoc['Longitude'];
        }
        return post;
      }).toList());

      return missingpets;
    } catch (e) {
      developer.log('Error fetching nearby found pets: $e');
      return [];
    }
  }

  // Added upload donation function
  @override
  Future<void> uploadDonation(List<File> images, String selectedChip, Map<String, dynamic> petData) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();

    try {

      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(postID);

      String post = petData['post'];
      String bankName = petData['bank_type'];
      String accountName = petData['account_name'];
      String accountNumber = petData['account_number'];
      String donationType = petData['donation_type'];
      String purposeOfDonation = petData['purpose_of_donation'];
      String estimatedAmount = petData['amount'];

      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      // Create a new document in PetDetailsCollection
      DocumentReference petRef = _firestore.collection('DonationDetails').doc(postID);
      await petRef.set({
        'BankHolder': accountName,
        'BankName': bankName,
        'AccountNumber': accountNumber,
        'DonationType': donationType,
        'PurposeOfDonation': purposeOfDonation,
        'EstimatedAmount': estimatedAmount,
        'Status': 'Ongoing', // put paused and fullfilled
      });

      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created a donation post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      ToastComponent().showMessage(AppColors.orange, '$selectedChip data added successfully');

      // Upload images concurrently and store their URLs in the images sub-collection
      List<Future<void>> uploadTasks = images.map((File image) async {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _firebaseStorage.ref().child('PostFolder/$postID/$fileName.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add image URL to the images sub-collection
        await postRef.collection('ImageCollection').add({
          'FileUrl': downloadUrl,
          'FileName': '$fileName.jpg',
        });
      }).toList();


      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      ToastComponent().showMessage(AppColors.orange, '$selectedChip data added successfully');
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }



}