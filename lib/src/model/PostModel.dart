import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  final String postId;
  final String postDescription;
  final String postOwnerId;
  final String category;
  final Timestamp timestamp;
  final List<String> imageUrls;
  final String postOwnerName;
  final String profileUrl;

  PostModel({
    required this.postId,
    required this.postDescription,
    required this.postOwnerId,
    required this.category,
    required this.timestamp,
    required this.imageUrls,
    required this.postOwnerName,
    required this.profileUrl,
  });

  static Future<PostModel> fromDocument(DocumentSnapshot doc) async {
    var imageUrls = <String>[];
    var imagesCollection = await doc.reference.collection('ImageCollection').get();
    for (var imageDoc in imagesCollection.docs) {
      imageUrls.add(imageDoc['FileUrl']);
    }

    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(doc['PostOwnerID']).get();

    return PostModel(
      postId: doc.id,
      postDescription: doc['PostDescription'],
      postOwnerId: doc['PostOwnerID'],
      category: doc['Category'],
      timestamp: doc['Timestamp'],
      imageUrls: imageUrls,
      postOwnerName: userDoc['Name'],
      profileUrl: userDoc['ProfileUrl'],
    );
  }
}