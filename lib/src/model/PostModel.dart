import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_welfrare_ph/src/model/TagModel.dart';

class PostModel {
  final String postId;
  final String postDescription;
  final String postOwnerId;
  final String category;
  final Timestamp timestamp;
  final List<String> imageUrls;
  final List<TagModel> tags;
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
  String petProvince = '';
  String petCity = '';
  String petBarangay = '';
  String petRegion = '';
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
  String petProvinceAdopt = '';
  String petCityAdopt = '';
  String petBarangayAdopt = '';
  String petRegionAdopt = '';
  String regProCiBagAdopt = '';
  String dateAdopt = '';
  String petSizeAdopt = '';
  String StatusAdopt = '';
  String petOwnernName = '';
  double lat = 0.0;
  double long = 0.0;
  String accountNumber = '';
  String bankHolder = '';
  String donationType = '';
  String purposeOfDonation = '';
  String estimatedAmount = '';
  String statusDonation = '';
  String bankName = '';
  String rescueAddress ='';
  String rescueBreed = '';
  String rescuePetColor ='';
  String rescuePetType ='';
  String rescuePetSize='';
  String rescueStatus='';
  String rescuePetGender='';
  String establisHment_Clinic_Name='';
  String establismentAdddress='';
  String establismentProvinces='';
  String establismentCity='';
  String establismentBarangay='';
  String establismentRegion='';


  PostModel({
    required this.postId,
    required this.postDescription,
    required this.postOwnerId,
    required this.category,
    required this.timestamp,
    required this.imageUrls,
    required this.tags,
    required this.postOwnerName,
    required this.profileUrl,
  });

  static Future<PostModel> fromDocument(DocumentSnapshot doc) async {
    var imageUrls = <String>[];
    var imagesCollection = await doc.reference.collection('ImageCollection').get();
    for (var imageDoc in imagesCollection.docs) {
      imageUrls.add(imageDoc['FileUrl']);
    }

    var tagList = <TagModel>[];
    var tagsCollection = await doc.reference.collection('TagsCollection').get();
    for (var tagDoc in tagsCollection.docs) {
      tagList.add(TagModel.fromDocument(tagDoc));
    }

    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(doc['PostOwnerID']).get();
    var petDoc = await FirebaseFirestore.instance.collection('PetDetailsCollection').doc(doc.id).get();
    var petDocAdopt = await FirebaseFirestore.instance.collection('AdoptionDetails').doc(doc.id).get();
    var donationDoc = await FirebaseFirestore.instance.collection('DonationDetails').doc(doc.id).get();
    var rescueDoc = await FirebaseFirestore.instance.collection('PetRescueDetails').doc(doc.id).get();
    var establishmentDoc = await FirebaseFirestore.instance.collection('VetAndTravelDetails').doc(doc.id).get();

    print('Rescue Document Data: ${rescueDoc.data()}');

    return PostModel(
      postId: doc.id,
      postDescription: doc['PostDescription'],
      postOwnerId: doc['PostOwnerID'],
      category: doc['Category'],
      timestamp: doc['Timestamp'],
      imageUrls: imageUrls,
      tags: tagList,
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
      ..petProvince = petDoc.data()?['Province'] ?? ''
      ..petCity = petDoc.data()?['City'] ?? ''
      ..petBarangay = petDoc.data()?['Barangay'] ?? ''
      ..petRegion = petDoc.data()?['Region'] ?? ''
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
      ..petProvinceAdopt = petDocAdopt.data()?['Province'] ?? ''
      ..petCityAdopt = petDocAdopt.data()?['City'] ?? ''
      ..petBarangayAdopt = petDocAdopt.data()?['Barangay'] ?? ''
      ..petRegionAdopt = petDocAdopt.data()?['Region'] ?? ''
      ..lat = petDoc.data()?['Latitude'] ?? 0.0
      ..long = petDoc.data()?['Longitude'] ?? 0.0
     ..accountNumber = donationDoc.data()?['AccountNumber'] ?? ''
      ..bankName = donationDoc.data()?['BankName'] ?? ''
       ..purposeOfDonation = donationDoc.data()?['PurposeOfDonation'] ?? ''
      ..bankHolder = donationDoc.data()?['BankHolder'] ?? ''
      ..donationType = donationDoc.data()?['DonationType'] ?? ''
      ..estimatedAmount = donationDoc.data()?['EstimatedAmount'] ?? ''
      ..statusDonation = donationDoc.data()?['Status'] ?? ''
      ..rescueAddress = rescueDoc.data()?['Address'] ?? ''
      ..rescueBreed = rescueDoc.data()?['PetBreed'] ?? ''
      ..rescuePetColor = rescueDoc.data()?['PetColor'] ?? ''
      ..rescuePetType = rescueDoc.data()?['PetType'] ?? ''
      ..rescuePetSize = rescueDoc.data()?['PetSize'] ?? ''
      ..rescueStatus = rescueDoc.data()?['Status'] ?? ''
      ..rescuePetGender = rescueDoc.data()?['PetGender'] ?? ''
      ..establisHment_Clinic_Name = establishmentDoc.data()?['ClinicName'] ?? ''
     ..establismentAdddress = establishmentDoc.data()?['Address'] ?? ''
      ..establismentProvinces = establishmentDoc.data()?['Province'] ?? ''
      ..establismentCity = establishmentDoc.data()?['City'] ?? ''
      ..establismentBarangay = establishmentDoc.data()?['Barangay'] ?? ''
      ..establismentRegion = establishmentDoc.data()?['Region'] ?? '';

  }
}