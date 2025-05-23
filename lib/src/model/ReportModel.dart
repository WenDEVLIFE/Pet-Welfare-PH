import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String description;
  final String filePath;

  ReportModel ({
    required this.id,
    required this.description,
    required this.filePath,
  });

   factory ReportModel.fromDocumentSnapshot(DocumentSnapshot doc){
     return ReportModel(
         id:  doc.id,
         description: doc['Reason'],
         filePath:  doc['FilePath'],
     );

   }
}