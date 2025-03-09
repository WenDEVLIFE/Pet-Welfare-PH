import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postDescription;
  final String postOwnerId;
  final String category;
  final Timestamp timestamp;
  final List<String> imageUrls;

  PostModel({
    required this.postId,
    required this.postDescription,
    required this.postOwnerId,
    required this.category,
    required this.timestamp,
    required this.imageUrls,
  });

  static Future<PostModel> fromDocument(DocumentSnapshot doc) async {
    var imageUrls = <String>[];
    var imagesCollection = await doc.reference.collection('ImageCollection').get();
    for (var imageDoc in imagesCollection.docs) {
      imageUrls.add(imageDoc['FileUrl']);
    }

    return PostModel(
      postId: doc['PostID'],
      postDescription: doc['PostDescription'],
      postOwnerId: doc['PostOwnerID'],
      category: doc['Category'],
      timestamp: doc['Timestamp'],
      imageUrls: imageUrls,
    );
  }
}