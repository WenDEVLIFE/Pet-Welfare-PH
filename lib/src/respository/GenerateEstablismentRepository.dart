import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'dart:developer' as developer;

abstract class GenerateEstablishmentRepository {
  Stream<List<EstablishmentModel>> getEstablishment();

  Future <List<EstablishmentModel>>getNearbyEstablishments(double lat, double long, double radiusInKm);
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

  // Get the nearby establishments
  @override
  Future<List<EstablishmentModel>> getNearbyEstablishments(double lat, double long, double radiusInK) async {
    try {
      // Define the radius in kilometers
      double radiusInKm = radiusInK;

      // Calculate the bounds for the query
      double latDelta = radiusInKm / 111.0; // 1 degree of latitude is approximately 111 km
      double longDelta = radiusInKm / (111.0 * cos(lat * pi / 180.0));

      // Query Firestore for found pets within the bounds in PostCollection
      QuerySnapshot establishmentCollection = await _firestore.collection('LocationCollection')
          .where('EstablishmentLat', isGreaterThanOrEqualTo: lat - latDelta)
          .where('EstablishmentLat', isLessThanOrEqualTo: lat + latDelta)
          .where('EstablishmentLong', isGreaterThanOrEqualTo: long - longDelta)
          .where('EstablishmentLong', isLessThanOrEqualTo: long + longDelta)
          .get();

      // For each post, query the PetDetailsCollection to get the corresponding pet details
      List<EstablishmentModel> establisment = await Future.wait(establishmentCollection.docs.map((doc) async {
        var post = await EstablishmentModel.fromDocumentSnapshot(doc);
        return post;
      }).toList());

      return establisment;
    } catch (e) {
      developer.log('Error fetching nearby found pets: $e');
      return [];
    }
  }
}