import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentModel {
  final String id;
  final String establishmentName;
  final String establishmentDescription;
  final String establishmentAddress;
  final String establishmentPhoneNumber;
  final String establishmentEmail;
  final String establishmentPicture;
  final double establishmentLat;
  final double establishmentLong;
  final String establishmentType;
  final String establishmentOwnerID;
  final String establishmentOwnerName;
  final String establishmentStatus;

  EstablishmentModel({
    required this.id,
    required this.establishmentName,
    required this.establishmentDescription,
    required this.establishmentAddress,
    required this.establishmentPhoneNumber,
    required this.establishmentEmail,
    required this.establishmentPicture,
    required this.establishmentLat,
    required this.establishmentLong,
    required this.establishmentType,
    required this.establishmentOwnerID,
    required this.establishmentOwnerName,
    required this.establishmentStatus,
  });

  factory EstablishmentModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return EstablishmentModel(
      id: doc.id,
      establishmentName: doc['EstablishmentName'],
      establishmentDescription: doc['EstablishmentDescription'],
      establishmentAddress: doc['EstablishmentAddress'],
      establishmentPhoneNumber: doc['EstablishmentPhoneNumber'],
      establishmentEmail: doc['EstablishmentEmail'],
      establishmentPicture: doc['EstablishmentPictureUrl'],
      establishmentLat: doc['EstablishmentLat'],
      establishmentLong: doc['EstablishmentLong'],
      establishmentType: doc['EstablishmentType'],
      establishmentOwnerID: doc['EstablishmentOwnerID'],
      establishmentOwnerName: doc['EstablishmentOwnerName'],
      establishmentStatus: doc['EstablishmentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishmentName': establishmentName,
      'establishmentDescription': establishmentDescription,
      'establishmentAddress': establishmentAddress,
      'establishmentPhoneNumber': establishmentPhoneNumber,
      'establishmentEmail': establishmentEmail,
      'establishmentPicture': establishmentPicture,
      'establishmentLat': establishmentLat,
      'establishmentLong': establishmentLong,
      'establishmentType': establishmentType,
      'establishmentOwnerID': establishmentOwnerID,
      'establishmentOwnerName': establishmentOwnerName,
      'establishmentStatus': establishmentStatus,
    };
  }

  factory EstablishmentModel.fromJson(Map<String, dynamic> json) {
    return EstablishmentModel(
      id: json['id'],
      establishmentName: json['establishmentName'],
      establishmentDescription: json['establishmentDescription'],
      establishmentAddress: json['establishmentAddress'],
      establishmentPhoneNumber: json['establishmentPhoneNumber'],
      establishmentEmail: json['establishmentEmail'],
      establishmentPicture: json['establishmentPicture'],
      establishmentLat: json['establishmentLat'],
      establishmentLong: json['establishmentLong'],
      establishmentType: json['establishmentType'],
      establishmentOwnerID: json['establishmentOwnerID'],
      establishmentOwnerName: json['establishmentOwnerName'],
      establishmentStatus: json['establishmentStatus'],
    );
  }
}