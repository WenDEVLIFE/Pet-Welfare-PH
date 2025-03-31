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
  String petNameAdopt = '';
  String petTypeAdopt = '';
  String petBreedAdopt = '';
  String petGenderAdopt = '';
  String petAgeAdopt = '';
  String petColorAdopt = '';
  String petAddressAdopt = '';
  String regProCiBagAdopt = '';
  String dateAdopt = '';
  String petSizeAdopt = '';
  String PetTypeAdopt = '';
  String StatusAdopt = '';
  String petOwnernName = '';
  double lat = 0.0;
  double long = 0.0;
  String accountNumber = '';
  String bankHolder = '';
  String donationType = '';
  String estimatedAmount = '';
  String statusDonation = '';
  String bankName = '';

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
    var petDocAdopt = await FirebaseFirestore.instance.collection('AdoptionDetails').doc(doc.id).get();
    var donationDoc = await FirebaseFirestore.instance.collection('DonationDetails').doc(doc.id).get();

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
      ..Status = petDoc.data()?['Status'] ?? ''
     ..petNameAdopt = petDocAdopt.data()?['PetName'] ?? ''
      ..petTypeAdopt = petDocAdopt.data()?['PetType'] ?? ''
      ..petBreedAdopt = petDocAdopt.data()?['PetBreed'] ?? ''
      ..petGenderAdopt = petDocAdopt.data()?['PetGender'] ?? ''
      ..petAgeAdopt = petDocAdopt.data()?['PetAge'] ?? ''
      ..petColorAdopt = petDocAdopt.data()?['PetColor'] ?? ''
      ..petAddressAdopt = petDocAdopt.data()?['Address'] ?? ''
      ..regProCiBagAdopt = '${petDocAdopt.data()?['Region'] ?? ''}, ${petDocAdopt.data()?['Province'] ?? ''}, ${petDocAdopt.data()?['City'] ?? ''}, ${petDocAdopt.data()?['Barangay'] ?? ''}'
      ..dateAdopt = petDocAdopt.data()?['Date'] ?? ''
      ..petSizeAdopt = petDocAdopt.data()?['PetSize'] ?? ''
      ..StatusAdopt = petDocAdopt.data()?['Status'] ?? ''
      ..petOwnernName = userDoc.data()?['Name'] ?? ''
      ..lat = petDoc.data()?['Latitude'] ?? 0.0
      ..long = petDoc.data()?['Longitude'] ?? 0.0
     ..accountNumber = donationDoc.data()?['AccountNumber'] ?? ''
      ..bankName = donationDoc.data()?['BankName'] ?? ''
      ..bankHolder = donationDoc.data()?['BankHolder'] ?? ''
      ..donationType = donationDoc.data()?['DonationType'] ?? ''
      ..estimatedAmount = donationDoc.data()?['EstimatedAmount'] ?? ''
      ..statusDonation = donationDoc.data()?['Status'] ?? '';

  }
}