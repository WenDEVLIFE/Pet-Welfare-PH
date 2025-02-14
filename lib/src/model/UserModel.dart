import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String role;
  String status;
  String profileUrl;
  String idbackPath;
  String idfrontPath;
  String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.profileUrl,
    required this.idbackPath,
    required this.idfrontPath,
    required this.address,
  });

  // Convert a UserModel into a Map
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>?;
    return UserModel(
      uid: doc.id,
      name: data?['Name'] ?? '',
      email: data?['Email'] ?? '',
      role: data?['Role'] ?? '',
      status: data?['Status'] ?? 'Status',
      profileUrl: data?['ProfileUrl'] ?? '',
      idbackPath: data?['IDBackUrl'] ?? 'IDBackUrl',
      idfrontPath: data?['IDFrontUrl'] ?? 'IDFrontUrl',
      address: data?['Address'] ?? 'Address',
    );
  }
}