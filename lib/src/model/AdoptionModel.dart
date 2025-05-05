import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionModel {

  final String adoptionID;

  final String adoptionName;

  final String facebookUsername;

  final String phoneNum;

  final String email;

  final String address;

  final String adoptionType;

  final String region;

  final String province;

  final String city;

  final String barangay;



  AdoptionModel({
    required this.adoptionID,
    required this.adoptionName,
    required this.facebookUsername,
    required this.phoneNum,
    required this.email,
    required this.address,
    required this.adoptionType,
    required this.region,
    required this.province,
    required this.city,
    required this.barangay,
  });

  factory AdoptionModel.fromDocumentSnapshot(DocumentSnapshot doc){
    return AdoptionModel(
      adoptionID: doc.id ?? '',
      adoptionName: doc['Name'] ?? '',
      facebookUsername: doc['FacebookUsername'] ?? '',
      phoneNum: doc['Phone'] ?? '',
      email: doc['Email'] ?? '',
      address: doc['Address'] ?? '',
      adoptionType: doc['AdoptionType'] ?? '',
      region: doc['Region'] ?? '',
      province: doc['Province'] ?? '',
      city: doc['City'] ?? '',
      barangay: doc['Barangay'] ?? '',
    );
  }


}