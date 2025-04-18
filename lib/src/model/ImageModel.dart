import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String id;
  final String url;
  final String filename;



  ImageModel({
    required this.id,
    required this.url,
    required this.filename,
  });

  static ImageModel fromDocument(DocumentSnapshot doc) {
    return ImageModel(
      id: doc.id,
      url: doc['FileUrl'] ?? '',
      filename: doc['FileName'] ?? '',
    );
  }


}