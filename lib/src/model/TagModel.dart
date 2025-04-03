import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  final String id;
  final String name;

  TagModel({
    required this.id,
    required this.name,
  });


  static TagModel fromDocument(DocumentSnapshot doc) {
    return TagModel(
      id: doc.id,
      name: doc['name'],
    );
  }
}