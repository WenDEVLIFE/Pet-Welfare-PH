import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

abstract class PostRepository {
  Future<void> uploadPost(String postText, List<File> images, String category);
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

      // Upload images and store their URLs in the images sub-collection
      for (File image in images) {
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
      }
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }
}