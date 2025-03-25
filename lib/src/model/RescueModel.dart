import 'package:cloud_firestore/cloud_firestore.dart';

class RescueModel {
  final String id;
  final double latitude;
  final double longtitude;
  String name='';
  String role='';
  String profileUrl='';

  RescueModel({
    required this.id,
    required this.latitude,
    required this.longtitude
  });

  static Future<RescueModel> fromDocument(DocumentSnapshot doc) async{
    String id  = doc.id;
    var userdoc = await FirebaseFirestore.instance.collection('Users').doc(id).get();
    return RescueModel(
      id: id,
      latitude: doc['Latitude'],
      longtitude: doc['Longitude'],
    )
        ..name = userdoc['Name']
        ..role = userdoc['Role']
        ..profileUrl = userdoc['ProfileUrl'];

  }
}