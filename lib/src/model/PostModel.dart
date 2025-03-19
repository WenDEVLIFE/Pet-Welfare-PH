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
  String petName = '';
  String petType = '';
  String petBreed = '';
  String petGender = '';
  String petAge = '';
  String petColor = '';
  String petAddress = '';
  String petCollar = '';
  String regProCiBag = '';
  String date = '';
  String petSize = '';
  String PetType = '';
  String Status = '';

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
    var petDoc = await FirebaseFirestore.instance.collection('PetDetailsCollection').doc(doc.id).get();

    return PostModel(
      postId: doc.id,
      postDescription: doc['PostDescription'],
      postOwnerId: doc['PostOwnerID'],
      category: doc['Category'],
      timestamp: doc['Timestamp'],
      imageUrls: imageUrls,
      postOwnerName: userDoc['Name'],
      profileUrl: userDoc['ProfileUrl'],
    )
      ..petName = petDoc.data()?['PetName'] ?? ''
      ..petType = petDoc.data()?['PetType'] ?? ''
      ..petBreed = petDoc.data()?['PetBreed'] ?? ''
      ..petGender = petDoc.data()?['PetGender'] ?? ''
      ..petAge = petDoc.data()?['PetAge'] ?? ''
      ..petColor = petDoc.data()?['PetColor'] ?? ''
      ..petAddress = petDoc.data()?['Address'] ?? ''
      ..petCollar = petDoc.data()?['PetCollar'] ?? ''
      ..regProCiBag = '${petDoc.data()?['Region'] ?? ''}, ${petDoc.data()?['Province'] ?? ''}, ${petDoc.data()?['City'] ?? ''}, ${petDoc.data()?['Barangay'] ?? ''}'
      ..date = petDoc.data()?['Date'] ?? ''
      ..petSize = petDoc.data()?['PetSize'] ?? ''
      ..Status = petDoc.data()?['Status'] ?? '';
  }
}