import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';

abstract class GenerateEstablismentRepository {
  Stream<List<EstablishmentModel>> getEstablisment();
}

class GenerateEstablismentRepositoryImpl implements GenerateEstablismentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<EstablishmentModel>> getEstablisment() {
    try{
      return _firestore.collection('LocationCollection').snapshots().map((snapshot) => snapshot.docs.map((doc) => EstablishmentModel.fromDocumentSnapshot(doc)).toList());
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}