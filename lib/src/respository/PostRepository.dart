import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../model/CommentModel.dart';
import '../model/ImageModel.dart';
import '../model/TagModel.dart';
import '../utils/AppColors.dart';
import 'dart:developer' as developer;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_welfrare_ph/src/utils/enum.dart';
import 'package:pet_welfrare_ph/src/exceptions/firestore_exceptions.dart';

abstract class PostRepository {
  Future<void> uploadPost(String postText, List<File> images, String category, List<String> tags);
  Stream<List<PostModel>> getPosts();

  Future <void> uploadPetData(List<File> images, String selectedChip, Map<String, dynamic> petData, List<String> tags);

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

  Stream<List<PostModel>> getFindHome();

  Future <void> editComment(String postId, String commentId, String newCommentText);

  Future <void> uploadAdoption(List<File> images, String selectedChip, Map<String, dynamic> petData, List <String> tags);

  Stream<List<PostModel>> getPetAdoption();

  Future<List<PostModel>> getNearbyFoundPets(double lat, double long, double radiusInK);

  Future<List<PostModel>> getNearbyLostPets(double lat, double long, double radiusInK);

  Future <void> uploadDonation(List<File> images, String selectedChip, Map<String, dynamic> petData, List<String> tags);

  Future <void> uploadVetTravel(List<File> images, String selectedChip, Map<String, String> petData, List<String> tags);

  Future <void> uploadPetRescue(List<File> images, String selectedChip, Map<String, String> petRescueData, List<String> tags);

  Future <void> uploadReportAbuse(List<File> images, String selectedChip, Map<String, String> petData, List<String> tags);

  Future <void> editDetails(String selectedChip, Map<String, dynamic> petData, String postID);

  Future <void> addTag(String tag, String postID);

  Future<void> removeTag (String tag, String postID);

  Future <void> deleteImage(String imageId, String url, String postId);

  Future<void> addImage(String postID, File image);

  Future<Map<String, dynamic>> getPostDetails(String postId, String category);

  Stream  <List<ImageModel>> loadImage (String postId);
  Stream <List<TagModel>> getTagData (String postId);

  Future<void> deletePost(String category, String postId);

  Stream<List<PostModel>> getMyPost();

  Future<void> updatePetStatus(String postId, String category, String selectedStatus);

  Future <bool> isUserVerified();

}

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> uploadPost(String postText, List<File> images, String category, List<String> tags) async {
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

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }


      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created $category post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      if(images.isNotEmpty){
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
      }

      else{
        ToastComponent().showMessage(AppColors.orange, 'Post added successfully without images');
      }
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
  Future<void> uploadPetData(List<File> images, String selectedChip, Map<String, dynamic> petData, List<String> tags) async {
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

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});
        }
        await batch.commit();
      }

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

      // Add notification
      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created $selectedChip post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      // Upload images concurrently and store their URLs in the images sub-collection
      if (images.isNotEmpty) {
        List<Future<void>> uploadTasks = images.map((File image) async {
          try {
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
          } catch (e) {
            throw Exception('Failed to upload image: $e');
          }
        }).toList();

        // Wait for all uploads to complete
        await Future.wait(uploadTasks);

        ToastComponent().showMessage(AppColors.orange, 'Pet data and images added successfully');
      }

    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Added upload pet data
  @override
  Future<void> uploadAdoption(List<File> images, String selectedChip, Map<String, dynamic> petData, List<String> tags) async {
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

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }

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
      if(images.isNotEmpty){
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
      }

      ToastComponent().showMessage(AppColors.orange, 'Adoption data added successfully');
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
   if (user == null) {
      return Stream.value([]);
    }
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Pet Care Insights')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // get the pet adoption
  @override
  Stream<List<PostModel>> getPetAdoption() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Call for Aid')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }

  // get find home
  @override
  Stream<List<PostModel>> getFindHome() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore.collection('PostCollection')
        .where('Category', isEqualTo: 'Pets For Rescue')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Future<PostModel>> postFutures = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
      return await Future.wait(postFutures);
    });
  }



  // get the nearby found pets
  Future<List<PostModel>> getNearbyFoundPets(double lat, double long, double radiusInK) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }
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
  Future<void> uploadDonation(List<File> images, String selectedChip, Map<String, dynamic> petData, List<String> tags) async {
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

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }

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

      if(images.isNotEmpty){
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
      }

      ToastComponent().showMessage(AppColors.orange, '$selectedChip data added successfully');
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  // Added a function to upload vet travel
  @override
  Future<void> uploadVetTravel(List<File> images, String selectedChip, Map<String, String> petData, List<String> tags) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();

    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(
          postID);

      String post = petData['post']!;
      String clinicName = petData['clinic_name']!;
      String region = petData['region']!;
      String province = petData['province']!;
      String city = petData['city']!;
      String barangay = petData['barangay']!;
      String address = petData['address']!;

      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }

      // Create a new document in PetDetailsCollection
      DocumentReference petRef = _firestore.collection('VetTravelDetails').doc(
          postID);
      await petRef.set({
        'ClinicName': clinicName,
        'Region': region,
        'Province': province,
        'City': city,
        'Barangay': barangay,
        'Address': address,
      });

      DocumentReference notificationRef = _firestore.collection(
          'NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created a Vet Travel post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      ToastComponent().showMessage(
          AppColors.orange, '$selectedChip data added successfully');

      // Upload images concurrently and store their URLs in the images sub-collection
      if(images.isNotEmpty){
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
      }
      ToastComponent().showMessage(Colors.green, '$selectedChip data added successfully');
    } catch(e) {
      throw Exception('Failed to upload post: $e');
    }

  }

  @override
  Future<void> uploadPetRescue(List<File> images, String selectedChip, Map<String, String> petRescueData, List<String> tags) async {

    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();

    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(
          postID);

      String post = petRescueData['post']!;
      String petType = petRescueData['pet_type']!;
      String petBreed = petRescueData['pet_breed']!;
      String petColor = petRescueData['pet_color']!;
      String petGender = petRescueData['pet_gender']!;
      String petSize = petRescueData['pet_size']!;
      String address = petRescueData['address']!;

      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
      });

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }

      // Create a new document in PetDetailsCollection
      DocumentReference petRef = _firestore.collection('PetRescueDetails').doc(
          postID);
      await petRef.set({
        'PetType': petType,
        'PetBreed': petBreed,
        'PetColor': petColor,
        'PetGender': petGender,
        'PetSize': petSize,
        'Address': address,
        'Status': 'Still needing rescue', // still needing rescue, contained/temporarily fostered, rescued
      });

      DocumentReference notificationRef = _firestore.collection(
          'NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created a Pet Rescue post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

      ToastComponent().showMessage(
          AppColors.orange, '$selectedChip data added successfully');

      // Upload images concurrently and store their URLs in the images sub-collection
      List<Future<void>> uploadTasks = images.map((File image) async {
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference storageRef = _firebaseStorage.ref().child(
            'PostFolder/$postID/$fileName.jpg');
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
      ToastComponent().showMessage(Colors.green, '$selectedChip data added successfully');
    } catch(e) {
      throw Exception('Failed to upload post: $e');
    }
  }

  @override
  Future<void> uploadReportAbuse(List<File> images, String selectedChip, Map<String, String> petData, List<String> tags) async {
    User user = _firebaseAuth.currentUser!;
    String uuid = user.uid;
    var postID = Uuid().v4();
    try {
      // Create a new post document
      DocumentReference postRef = _firestore.collection('PostCollection').doc(postID);
      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': petData['post'],
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
         'Status': 'Will investigate', // Will investigate, ongoing investigation, case has been filed, case has been resolved, actions to be taken, etc.)
      });

      // Create a document for tag collection
      WriteBatch batch = _firestore.batch();
      if (tags.isNotEmpty) {
        for (String tag in tags) {
          DocumentReference tagRef = postRef.collection('TagsCollection').doc();
          batch.set(tagRef, {'tags': tag});

        }
        await  batch.commit();
      }


      DocumentReference notificationRef = _firestore.collection('NotificationCollection').doc();
      await notificationRef.set({
        'notificationID': notificationRef.id,
        'userID': uuid,
        'content': 'You have successfully created $selectedChip post',
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'Donation',
        'isRead': false,
      });

     if(images.isNotEmpty){
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
     }

    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }


  @override
  Future<Map<String, dynamic>> getPostDetails(String postId, String category) async {
    try {
      // Fetch the main post details
      DocumentSnapshot postSnapshot = await _firestore.collection('PostCollection').doc(postId).get();
      if (!postSnapshot.exists) {
        throw Exception('Post with ID $postId not found in PostCollection.');
      }

      Map<String, dynamic> postDetails = postSnapshot.data() as Map<String, dynamic>? ?? {};
      if (postDetails.isEmpty) {
        throw Exception('Post data for ID $postId is empty.');
      }

      // Map category to corresponding collection name
      final categoryToCollection = {
        'Missing Pets': 'PetDetailsCollection',
        'Found Pets': 'PetDetailsCollection',
        'Pet Adoption': 'AdoptionDetails',
        'Pets For Rescue': 'PetRescueDetails',
        'Pet Care Insights': 'VetTravelDetails',
        'Call for Aid': 'DonationDetails',
      };

      // Get the collection name based on the category
      String? collectionName = categoryToCollection[category];

      // Fetch additional details if a collection is determined
      if (collectionName != null) {
        DocumentSnapshot additionalDetailsSnapshot =
        await _firestore.collection(collectionName).doc(postId).get();

        if (additionalDetailsSnapshot.exists) {
          Map<String, dynamic> additionalDetails =
              additionalDetailsSnapshot.data() as Map<String, dynamic>? ?? {};
          postDetails.addAll(additionalDetails);
        }
      }

      return postDetails;
    } catch (e) {
      throw Exception('Failed to fetch post details for ID $postId: $e');
    }
  }

  // load the image
  Stream<List<ImageModel>> loadImage(String id) {
    return _firestore
        .collection('PostCollection')
        .doc(id)
        .collection('ImageCollection')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ImageModel.fromDocument(doc);
      }).toList();
    });
  }

  // load the tag
  Stream<List<TagModel>> getTagData(String id) {
    return _firestore
        .collection('PostCollection')
        .doc(id)
        .collection('TagsCollection')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TagModel.fromDocument(doc);
      }).toList();
    });
  }

  // Edit post in the database
@override
Future<void> editDetails(String selectedChip, Map<String, dynamic> petData, String postID) async {
  final postType = PostType.fromString(selectedChip);
  if (postType == PostType.unknown) {
    throw DataUpdateException('Unknown post type provided: $selectedChip');
  }

  final batch = _firestore.batch();

  final postDocRef = _firestore.collection('PostCollection').doc(postID);
  batch.update(postDocRef, {'PostDescription': petData['post']});

  switch (postType) {
    case PostType.petAppreciation:
    case PostType.pawsomeExperience:
    case PostType.protectOurPets:
    case PostType.communityAnnouncement:
      break;

    case PostType.missingPets:
    case PostType.foundPets:
      final detailsDocRef = _firestore.collection('PetDetailsCollection').doc(postID);
      final updateData = {
        'PetColor': petData['pet_color'],
        'PetAge': petData['pet_age'],
        'PetSize': petData['pet_size'],
        'PetType': petData['pet_type'],
        'PetGender': petData['pet_gender'],
        'Region': petData['region'],
        'Province': petData['province'],
        'City': petData['city'],
        'Latitude': petData['lat'],
        'Longitude': petData['long'],
        'Barangay': petData['barangay'],
        'Address': petData['address'],
      };
      if (petData['pet_type'] == 'Cat' || petData['pet_type'] == 'Dog') {
        updateData['PetBreed'] = petData['pet_breed'];
      }
      batch.update(detailsDocRef, updateData);
      break;
      
    case PostType.petAdoption:
      final adoptionDocRef = _firestore.collection('AdoptionDetails').doc(postID);
      final updateData = {
        'PetName': petData['pet_name'],
        'PetColor': petData['pet_color'],
        'PetAge': petData['pet_age'],
        'PetSize': petData['pet_size'],
        'PetGender': petData['pet_gender'],
        'Region': petData['region'],
        'Province': petData['province'],
        'City': petData['city'],
        'Barangay': petData['barangay'],
        'Address': petData['address'],
      };
      if (petData['pet_type'] == 'Cat' || petData['pet_type'] == 'Dog') {
          updateData['PetBreed'] = petData['pet_breed'];
      }
      batch.update(adoptionDocRef, updateData);
      break;

    case PostType.petsForRescue:
      final rescueDocRef = _firestore.collection('PetRescueDetails').doc(postID);
      final updateData = {
        'PetColor': petData['pet_color'],
        'PetSize': petData['pet_size'],
        'PetGender': petData['pet_gender'],
        'Address': petData['address'],
        'PetBreed' : petData['pet_breed'],
      };
      batch.update(rescueDocRef, updateData);
      break;

    case PostType.petCareInsights:
      final vetTravelDocRef = _firestore.collection('VetTravelDetails').doc(postID);
      final updateData = {
        'Region': petData['region'],
        'Province': petData['province'],
        'City': petData['city'],
        'ClinicName': petData['clinic_name'],
        'Barangay': petData['barangay'],
        'Address': petData['address'],
      };
      batch.update(vetTravelDocRef, updateData);
      break;

    case PostType.callForAid:
      final donationDocRef = _firestore.collection('DonationDetails').doc(postID);
      final updateData = {
        'BankHolder': petData['account_name'],
        'BankName': petData['bank_type'],
        'AccountNumber': petData['account_number'],
        'DonationType': petData['donation_type'],
        'PurposeOfDonation': petData['purpose_of_donation'],
        'EstimatedAmount': petData['amount'],
      };
      batch.update(donationDocRef, updateData);
      break;

    default:
    // handles the 'unknown' case.
      throw DataUpdateException('Logic for $selectedChip not implemented.');
  }

  try {
    await batch.commit().timeout(const Duration(seconds: 15));
  } on TimeoutException {
    // This is the "network is slow" indicator
    throw DataUpdateException('The network is slow, please try again in a moment.');
  } on FirebaseException catch (e) {
    // Handle specific Firestore errors
    throw DataUpdateException('An error occurred while saving: ${e.code}');
  } catch (e) {
    // Handle any other unexpected errors
    throw DataUpdateException('An unexpected error occurred. Please try again.');
  }
}

  // Edit an add tags in the database
  @override
  Future <void> addTag(String tag, String postID) async{

     QuerySnapshot tagSnapshot = await _firestore.collection('PostCollection').doc(postID).collection('TagsCollection').where('tag', isEqualTo: tag).get();

      if (tagSnapshot.docs.isEmpty) {
        DocumentReference tagRef = _firestore.collection('PostCollection').doc(postID).collection('TagsCollection').doc();
        await tagRef.set({
          'tags': tag,
        });
        ToastComponent().showMessage(AppColors.orange, 'Tag added successfully');
      } else {
        throw Exception('Tag already exists');
      }

  }

  // remove an add tags in the database
  @override
  Future <void> removeTag(String tag, String postID) async{
    QuerySnapshot tagSnapshot = await _firestore.collection('PostCollection').doc(postID).collection('TagsCollection').where('tags', isEqualTo: tag).get();

    if (tagSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in tagSnapshot.docs) {
        await doc.reference.delete();
      }
      ToastComponent().showMessage(AppColors.orange, 'Tag removed successfully');
    } else {
      throw Exception('Tag not found');
    }
  }


  // Remove image from the database
  @override
  Future<void> deleteImage(String imageId, String url, String postId) {
    return _firestore.collection('PostCollection').doc(postId).collection('ImageCollection').doc(imageId).delete().then((_) {
      // Remove the image from Firebase Storage
      Reference storageRef = _firebaseStorage.refFromURL(url);
      ToastComponent().showMessage(AppColors.orange, 'Image deleted successfully');
      return storageRef.delete();
    }).catchError((error) {
      throw Exception('Failed to delete image: $error');
    });
  }

  // Remove image from the storage
  Future<void> removeImageStorage(String imageId) async {
    try {
      Reference storageRef = _firebaseStorage.ref().child('PostFolder/$imageId');
      await storageRef.delete();
      ToastComponent().showMessage(AppColors.orange, 'Image removed successfully');
    } catch (e) {
      throw Exception('Failed to remove image: $e');
    }
  }

  // Add image to the database
  Future<void> addImage(String postID, File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _firebaseStorage.ref().child('PostFolder/$postID/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Add image URL to the images sub-collection
      await _firestore.collection('PostCollection').doc(postID).collection('ImageCollection').add({
        'FileUrl': downloadUrl,
        'FileName': '$fileName.jpg',
      });

      ToastComponent().showMessage(AppColors.orange, 'Image added successfully');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // This will delete the post
  @override
  Future<void> deletePost(String category, String postId) async {

    // Trim and log the category for debugging
    category = category.trim().toLowerCase();
    print('Deleting post with category: $category');

    try {
      // Fetch all images from the ImageCollection sub-collection
      QuerySnapshot imageSnapshot = await _firestore
          .collection('PostCollection')
          .doc(postId)
          .collection('ImageCollection')
          .get();

      // Delete each image from Firebase Storage
      if (imageSnapshot.docs.isNotEmpty) {
        for (var doc in imageSnapshot.docs) {
          String imageUrl = doc['FileUrl'];
          Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      // Delete the post and its related data based on the category
      if (category == 'pet appreciation' ||
          category == 'paw-some experience' ||
          category == 'protect our pets: report abuse' ||
          category == 'community announcement') {
        await _firestore.collection('PostCollection').doc(postId).delete();
      } else if (category == 'missing pets' || category.toLowerCase() == 'found pets') {
        await _firestore.collection('PostCollection').doc(postId).delete();
        await _firestore.collection('PetDetailsCollection').doc(postId).delete();
      } else if (category == 'pet adoption') {
        await _firestore.collection('PostCollection').doc(postId).delete();
        await _firestore.collection('AdoptionDetails').doc(postId).delete();
      } else if (category == 'pets for rescue') {
        await _firestore.collection('PostCollection').doc(postId).delete();
        await _firestore.collection('PetRescueDetails').doc(postId).delete();
      } else if (category == 'pet care insights') {
        await _firestore.collection('PostCollection').doc(postId).delete();
        await _firestore.collection('VetTravelDetails').doc(postId).delete();
      } else if (category == 'call for aid') {
        QuerySnapshot donationSnapshot = await _firestore
            .collection('PostCollection')
            .doc(postId)
            .collection('DonationCollection')
            .get();

        // Delete each document in the DonationCollection
        for (QueryDocumentSnapshot doc in donationSnapshot.docs) {
          await doc.reference.delete();
            String imageUrl = doc['TransactionPath'];
            Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
            await storageRef.delete();
            await doc.reference.delete(); // Delete the document in Firestore
        }
        await _firestore.collection('PostCollection').doc(postId).delete();
      } else {
        throw Exception('Invalid category');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // get the post owner post
@override
Stream<List<PostModel>> getMyPost() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Fluttertoast.showToast(msg: "User is not logged in.");
    return Stream.value([]);
  }

  String id = user.uid;

  return _firestore
      .collection('PostCollection')
      .where('PostOwnerID', isEqualTo: id)
      .snapshots()
      .handleError((error) {
        Fluttertoast.showToast(msg: "Error: Stream Error: $error");
      })
      .asyncMap((snapshot) async {
        if (snapshot.docs.isEmpty) {
          Fluttertoast.showToast(msg: "No posts found.");
          return [];
        }

        List<PostModel> posts = [];
        for (var doc in snapshot.docs) {
          try {
            final post = await PostModel.fromDocument(doc);
            posts.add(post);
          } catch (e) {
            Fluttertoast.showToast(msg: "Error: Error parsing document ${doc.id}");
          }
        }
        return posts;
      });
}

  @override
  Future<void> updatePetStatus(String postId, String category, String selectedStatus) async {
    if (category == 'Missing Pets' || category == 'Found Pets') {
      ToastComponent().showMessage(AppColors.orange, 'Status updated successfully');
      return _firestore.collection('PetDetailsCollection').doc(postId).update({
        'Status': selectedStatus,
      });
    } else if (category == 'Pet Adoption') {
      return _firestore.collection('AdoptionDetails').doc(postId).update({
        'Status': selectedStatus,
      });
    } else if (category == 'Protect Our Pets: Report Abuse') {
      return _firestore.collection('PostCollection').doc(postId).update({
        'Status': selectedStatus,
      });
    }
    else if (category == 'Call for Aid') {
      return _firestore.collection('DonationDetails').doc(postId).update({
        'Status': selectedStatus,
      });
    }
    else {
      throw Exception('Invalid category');
    }
  }

  @override
  Future<bool> isUserVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;

    // Get the document snapshot for the user
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .get();

    // Check if the document exists and the status is "Pending"
    if (documentSnapshot.exists) {
      String status = documentSnapshot['Status'];
      if (status == 'Pending') {
        // User is not verified
        return false;
      } else if (status == 'Approved') {
        // User is verified
        return true;
      } else {
        // Handle other statuses if needed
        throw Exception('Unknown user status: $status');
      }
    }

    // Return false if the document does not exist
    return false;
  }


}