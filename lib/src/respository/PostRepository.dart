import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_welfrare_ph/src/model/PostModel.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

abstract class PostRepository {
  Future<void> uploadPost(String postText, List<File> images, String category);
  Stream<List<PostModel>> getPosts();

  Future <void> uploadPetData(List<File> images, String selectedChip, Map<String, Object> petData);
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
    return _firestore.collection('PostCollection').snapshots().asyncMap((snapshot) async {
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
      String petColor = petData['pet_color'];
      String petAge = petData['pet_age'];
      String region = petData['region'];
      String province = petData['province'];
      String city = petData['city'];
      String barangay = petData['barangay'];
      String address = petData['address'];
      double lat = petData['lat'];
      double long = petData['long'];


      await postRef.set({
        'PostID': postID,
        'PostOwnerID': uuid,
        'PostDescription': post,
        'Category': selectedChip,
        'Timestamp': FieldValue.serverTimestamp(),
        'PetName': petName,
        'PetType': petType,
        'PetBreed': petBreed,
        'PetColor': petColor,
        'PetAge': petAge,
        'Region': region,
        'Province': province,
        'City': city,
        'Barangay': barangay,
        'Address': address,
        'Latitude': lat,
        'Longitude': long,
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

}