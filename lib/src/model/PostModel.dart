import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_welfrare_ph/src/model/TagModel.dart';

class PostModel {
  // --- PROPERTIES ---
  final String postId;
  final String postDescription;
  final String postOwnerId;
  final String category;
  final Timestamp timestamp;
  late List<String> imageUrls;
  late List<TagModel> tags;

  // --- STREAMS FOR REAL-TIME DATA ---
  final Stream<DocumentSnapshot> userStream;
  final Stream<DocumentSnapshot> petDocStream;
  final Stream<DocumentSnapshot> petDocAdoptStream;
  final Stream<DocumentSnapshot> donationDocStream;
  final Stream<DocumentSnapshot> rescueDocStream;
  final Stream<DocumentSnapshot> establishmentDocStream;
  final Stream<DocumentSnapshot> postCollectionStream;
  final Stream<List<TagModel>>? tagStream;
  final Stream<List<String>>? imageStream;

  // --- MUTABLE DATA FIELDS ---
  late String postOwnerName;
  late String profileUrl;
  String caseStatus = '';
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
  String rescueAddress = '';
  String rescueBreed = '';
  String rescuePetColor = '';
  String rescuePetType = '';
  String rescuePetSize = '';
  String rescueStatus = '';
  String rescuePetGender = '';
  String establisHment_Clinic_Name = '';
  String establismentAdddress = '';
  String establismentProvinces = '';
  String establismentCity = '';
  String establismentBarangay = '';
  String establismentRegion = '';

  // --- STREAM SUBSCRIPTIONS FOR CLEANUP ---
  StreamSubscription<List<TagModel>>? _tagSubscription;
  StreamSubscription<List<String>>? _imageSubscription;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  StreamSubscription<DocumentSnapshot>? _petDocSubscription;
  StreamSubscription<DocumentSnapshot>? _petDocAdoptSubscription;
  StreamSubscription<DocumentSnapshot>? _donationDocSubscription;
  StreamSubscription<DocumentSnapshot>? _rescueDocSubscription;
  StreamSubscription<DocumentSnapshot>? _establishmentDocSubscription;
  StreamSubscription<DocumentSnapshot>? _postCollectionSubscription;

  // --- CONSTRUCTOR ---
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
    required this.userStream,
    required this.petDocStream,
    required this.petDocAdoptStream,
    required this.donationDocStream,
    required this.rescueDocStream,
    required this.establishmentDocStream,
    required this.postCollectionStream,
    this.tagStream,
    this.imageStream,
  });

  // --- FACTORY CONSTRUCTOR ---
  static Future<PostModel> fromDocument(DocumentSnapshot doc) async {
    // Efficiently fetch all initial data in parallel
    final results = await Future.wait([
      FirebaseFirestore.instance.collection('Users').doc(doc['PostOwnerID']).get(),
      FirebaseFirestore.instance.collection('PetDetailsCollection').doc(doc.id).get(),
      FirebaseFirestore.instance.collection('AdoptionDetails').doc(doc.id).get(),
      FirebaseFirestore.instance.collection('DonationDetails').doc(doc.id).get(),
      FirebaseFirestore.instance.collection('PetRescueDetails').doc(doc.id).get(),
      FirebaseFirestore.instance.collection('VetTravelDetails').doc(doc.id).get(),
      doc.reference.collection('PostCollection').doc(doc.id).get(),
      doc.reference.collection('ImageCollection').get(),
      doc.reference.collection('TagsCollection').get(),
    ]);

    // Assign fetched data to local variables
    final userDoc = results[0] as DocumentSnapshot;
    final petDoc = results[1] as DocumentSnapshot;
    final petDocAdopt = results[2] as DocumentSnapshot;
    final donationDoc = results[3] as DocumentSnapshot;
    final rescueDoc = results[4] as DocumentSnapshot;
    final establishmentDoc = results[5] as DocumentSnapshot;
    final postCollection = results[6] as DocumentSnapshot;
    final imagesCollection = results[7] as QuerySnapshot;
    final tagsCollection = results[8] as QuerySnapshot;

    final imageUrls = imagesCollection.docs.map((d) => d['FileUrl'] as String).toList();
    final tagList = tagsCollection.docs.map((d) => TagModel.fromDocument(d)).toList();
    final userDocData = userDoc.data() as Map<String, dynamic>?;

    // Create the real-time streams
    final userId = doc['PostOwnerID'];
    final userStream = FirebaseFirestore.instance.collection('Users').doc(userId).snapshots();
    final petDocStream = FirebaseFirestore.instance.collection('PetDetailsCollection').doc(doc.id).snapshots();
    final petDocAdoptStream = FirebaseFirestore.instance.collection('AdoptionDetails').doc(doc.id).snapshots();
    final donationDocStream = FirebaseFirestore.instance.collection('DonationDetails').doc(doc.id).snapshots();
    final rescueDocStream = FirebaseFirestore.instance.collection('PetRescueDetails').doc(doc.id).snapshots();
    final establishmentDocStream = FirebaseFirestore.instance.collection('VetTravelDetails').doc(doc.id).snapshots();
    final postCollectionStream = doc.reference.collection('PostCollection').doc(doc.id).snapshots();
    final tagStream = doc.reference.collection('TagsCollection').snapshots().map((s) => s.docs.map((d) => TagModel.fromDocument(d)).toList());
    final imageStream = doc.reference.collection('ImageCollection').snapshots().map((s) => s.docs.map((d) => d['FileUrl'] as String).toList());

    // Create the PostModel instance
    return PostModel(
      postId: doc.id,
      postDescription: doc['PostDescription'],
      postOwnerId: doc['PostOwnerID'],
      category: doc['Category'],
      timestamp: doc['Timestamp'],
      imageUrls: imageUrls,
      tags: tagList,
      postOwnerName: userDocData?['Name'] ?? 'Unknown User',
      profileUrl: userDocData?['ProfileUrl'] ?? '',
      tagStream: tagStream,
      imageStream: imageStream,
      userStream: userStream,
      petDocStream: petDocStream,
      petDocAdoptStream: petDocAdoptStream,
      donationDocStream: donationDocStream,
      rescueDocStream: rescueDocStream,
      establishmentDocStream: establishmentDocStream,
      postCollectionStream: postCollectionStream,
    )
    // Use cascade operator (..) to populate mutable fields with initial data
      .._populateFromDocs(
        petDoc: petDoc,
        petDocAdopt: petDocAdopt,
        donationDoc: donationDoc,
        rescueDoc: rescueDoc,
        establishmentDoc: establishmentDoc,
        postCollection: postCollection,
        userDoc: userDoc,
      );
  }

  // Helper method to populate data, used by both factory and stream listeners
  void _populateFromDocs({
    DocumentSnapshot? userDoc,
    DocumentSnapshot? petDoc,
    DocumentSnapshot? petDocAdopt,
    DocumentSnapshot? donationDoc,
    DocumentSnapshot? rescueDoc,
    DocumentSnapshot? establishmentDoc,
    DocumentSnapshot? postCollection,
  }) {
    if (userDoc != null) {
      final data = userDoc.data() as Map<String, dynamic>?;
      postOwnerName = data?['Name'] ?? 'Unknown User';
      profileUrl = data?['ProfileUrl'] ?? '';
      petOwnernName = data?['Name'] ?? '';
    }
    if (petDoc != null) {
      final data = petDoc.data() as Map<String, dynamic>?;
      petName = data?['PetName'] ?? '';
      petType = data?['PetType'] ?? '';
      petBreed = data?['PetBreed'] ?? '';
      petGender = data?['PetGender'] ?? '';
      petAge = data?['PetAge'] ?? '';
      petColor = data?['PetColor'] ?? '';
      petAddress = data?['Address'] ?? '';
      petCollar = data?['PetCollar'] ?? '';
      petProvince = data?['Province'] ?? '';
      petCity = data?['City'] ?? '';
      petBarangay = data?['Barangay'] ?? '';
      petRegion = data?['Region'] ?? '';
      regProCiBag = '${data?['Region'] ?? ''}, ${data?['Province'] ?? ''}, ${data?['City'] ?? ''}, ${data?['Barangay'] ?? ''}';
      date = data?['Date'] ?? '';
      petSize = data?['PetSize'] ?? '';
      Status = data?['Status'] ?? '';
      lat = data?['Latitude'] ?? 0.0;
      long = data?['Longitude'] ?? 0.0;
    }
    if (petDocAdopt != null) {
      final data = petDocAdopt.data() as Map<String, dynamic>?;
      petNameAdopt = data?['PetName'] ?? '';
      petTypeAdopt = data?['PetType'] ?? '';
      petBreedAdopt = data?['PetBreed'] ?? '';
      petGenderAdopt = data?['PetGender'] ?? '';
      petAgeAdopt = data?['PetAge'] ?? '';
      petColorAdopt = data?['PetColor'] ?? '';
      petAddressAdopt = data?['Address'] ?? '';
      regProCiBagAdopt = '${data?['Region'] ?? ''}, ${data?['Province'] ?? ''}, ${data?['City'] ?? ''}, ${data?['Barangay'] ?? ''}';
      dateAdopt = data?['Date'] ?? '';
      petSizeAdopt = data?['PetSize'] ?? '';
      StatusAdopt = data?['Status'] ?? '';
      petProvinceAdopt = data?['Province'] ?? '';
      petCityAdopt = data?['City'] ?? '';
      petBarangayAdopt = data?['Barangay'] ?? '';
      petRegionAdopt = data?['Region'] ?? '';
    }
    if (donationDoc != null) {
      final data = donationDoc.data() as Map<String, dynamic>?;
      accountNumber = data?['AccountNumber'] ?? '';
      bankName = data?['BankName'] ?? '';
      purposeOfDonation = data?['PurposeOfDonation'] ?? '';
      bankHolder = data?['BankHolder'] ?? '';
      donationType = data?['DonationType'] ?? '';
      estimatedAmount = data?['EstimatedAmount'] ?? '';
      statusDonation = data?['Status'] ?? '';
    }
    if (rescueDoc != null) {
      final data = rescueDoc.data() as Map<String, dynamic>?;
      rescueAddress = data?['Address'] ?? '';
      rescueBreed = data?['PetBreed'] ?? '';
      rescuePetColor = data?['PetColor'] ?? '';
      rescuePetType = data?['PetType'] ?? '';
      rescuePetSize = data?['PetSize'] ?? '';
      rescueStatus = data?['Status'] ?? '';
      rescuePetGender = data?['PetGender'] ?? '';
    }
    if (establishmentDoc != null) {
      final data = establishmentDoc.data() as Map<String, dynamic>?;
      establisHment_Clinic_Name = data?['ClinicName'] ?? '';
      establismentAdddress = data?['Address'] ?? '';
      establismentProvinces = data?['Province'] ?? '';
      establismentCity = data?['City'] ?? '';
      establismentBarangay = data?['Barangay'] ?? '';
      establismentRegion = data?['Region'] ?? '';
    }
    if (postCollection != null) {
      final data = postCollection.data() as Map<String, dynamic>?;
      caseStatus = data?['CaseStatus'] ?? '';
    }
  }

  // --- STREAM MANAGEMENT ---
  void initializeStreams({required Function onUpdate}) {

    _userSubscription = userStream.listen((doc) {
      _populateFromDocs(userDoc: doc);
      onUpdate();
    });

    _petDocSubscription = petDocStream.listen((doc) {
      _populateFromDocs(petDoc: doc);
      onUpdate();
    });

    _petDocAdoptSubscription = petDocAdoptStream.listen((doc) {
      _populateFromDocs(petDocAdopt: doc);
      onUpdate();
    });

    _donationDocSubscription = donationDocStream.listen((doc) {
      _populateFromDocs(donationDoc: doc);
      onUpdate();
    });

    _rescueDocSubscription = rescueDocStream.listen((doc) {
      _populateFromDocs(rescueDoc: doc);
      onUpdate();
    });

    _establishmentDocSubscription = establishmentDocStream.listen((doc) {
      _populateFromDocs(establishmentDoc: doc);
      onUpdate();
    });

    _postCollectionSubscription = postCollectionStream.listen((doc) {
      _populateFromDocs(postCollection: doc);
      onUpdate();
    });
  }

  void disposeStreams() {
    _userSubscription?.cancel();
    _petDocSubscription?.cancel();
    _petDocAdoptSubscription?.cancel();
    _donationDocSubscription?.cancel();
    _rescueDocSubscription?.cancel();
    _establishmentDocSubscription?.cancel();
    _postCollectionSubscription?.cancel();
  }
}