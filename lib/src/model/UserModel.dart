import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String role;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert a UserModel into a Map
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      name: doc['Name'],
      email: doc['Email'],
      role: doc['Role'],
    );
  }
}