import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../utils/AppColors.dart';

abstract class PostRepository {
  Future<void> uploadPost(String postText, List<File> images, String category);
  Stream<List<PostModel>> getPosts();

  Future <void> uploadPetData(List<File> images, String selectedChip, Map<String, Object> petData);

  Future <void> addReaction(String postId, String reaction);

  Future<bool> hasUserReacted(String postId);

  Future<int> getReactionCount(String postId);

  Future<void> removeReaction(String postId);

  Future<String?> getUserReaction(String postId);
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
      List<PostModel> posts = [];
      for (var doc in snapshot.docs) {
        var post = await PostModel.fromDocument(doc);
        posts.add(post);
      }
      return posts;
    });
  }

  @override
  Future <void> uploadPetData(List<File> images, String selectedChip, Map<String, dynamic> petData) async {

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

      if(petType=='Cat' ||petType== 'Dog'){
        await postRef.set({
          'PostID': postID,
          'PostOwnerID': uuid,
          'PostDescription': post,
          'Category': selectedChip,
          'Timestamp': FieldValue.serverTimestamp(),
          'PetName': petName,
          'PetType': petType,
          'PetGender':gender,
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
          'Longitude': long,
        });
      }

      else{
        await postRef.set({
          'PostID': postID,
          'PostOwnerID': uuid,
          'PostDescription': post,
          'Category': selectedChip,
          'Timestamp': FieldValue.serverTimestamp(),
          'PetName': petName,
          'PetType': petType,
          'PetGender':gender,
          'PetSize': size,
          'PetColor': color,
          'PetBreed': petBreed,
          'PetAge': petAge,
          'Region': region,
          'Province': province,
          'City': city,
          'Barangay': barangay,
          'Address': address,
          'Latitude': lat,
          'Longitude': long,
        });
      }

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

  @override
  Future<bool> hasUserReacted(String postId) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);
    DocumentSnapshot reactionSnapshot = await reactionRef.get();

    return reactionSnapshot.exists;
  }

  @override
  Future<int> getReactionCount(String postId) async {
    QuerySnapshot reactionSnapshot = await _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').get();
    return reactionSnapshot.docs.length;
  }

  @override
  Future<void> removeReaction(String postId) async {
    User user = _firebaseAuth.currentUser!;
    String userId = user.uid;

    DocumentReference reactionRef = _firestore.collection('PostCollection').doc(postId).collection('ReactionCollection').doc(userId);
    await reactionRef.delete();
  }

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

}