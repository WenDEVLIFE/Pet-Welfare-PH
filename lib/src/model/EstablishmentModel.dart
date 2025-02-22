import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentModel {
  String uid;
  String ProfilePath;
  String establishmentName;
  String establishmentAddress;
  String latitude;
  String longitude;
  String phoneNumber;
  String status;

  EstablishmentModel({
    required this.uid,
    required this.ProfilePath,
    required this.establishmentName,
    required this.establishmentAddress,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.status,
  });

  // This will convert the data from the database to a model
  factory EstablishmentModel.fromDocumentSnapshot(DocumentSnapshot doc){
    return EstablishmentModel(
      uid: doc.id,
      ProfilePath: doc['EstablishmentPicture'],
      establishmentName: doc['EstablishmentName'],
      establishmentAddress: doc['EstablishmentAddress'],
      latitude: doc['EstablishmentLat'],
      longitude: doc['EstablishmentLong'],
      phoneNumber: doc['EstablishmentPhoneNumber'],
      status: doc['EstablishmentStatus'],
    );
  }

}