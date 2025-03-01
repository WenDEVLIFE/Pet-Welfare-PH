import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';

abstract class GenerateEstablishmentRepository {
  Stream<List<EstablishmentModel>> getEstablishment();
}

class GenerateEstablishmentRepositoryImpl implements GenerateEstablishmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<EstablishmentModel>> getEstablishment() {
    try {
      return _firestore
          .collection('LocationCollection')
          .where('EstablishmentStatus', isEqualTo: "Approved")
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => EstablishmentModel.fromDocumentSnapshot(doc))
          .toList());
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}