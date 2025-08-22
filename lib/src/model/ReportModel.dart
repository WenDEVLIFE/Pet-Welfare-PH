import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String description;
  final String filePath;
  final String timestamp;

  ReportModel ({
    required this.id,
    required this.description,
    required this.filePath,
    required this.timestamp,
  });

   factory ReportModel.fromDocumentSnapshot(DocumentSnapshot doc){
     return ReportModel(
         id:  doc.id,
         description: doc['Reason'],
         filePath:  doc['FilePath'],
          timestamp: (doc['timestamp'] as Timestamp).toDate().toString(),
     );

   }
}