import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pet_welfrare_ph/src/model/EstablishmentModel.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

abstract class Locationrespository {
  Future<void> addLocation(Map<String, dynamic> locationData, BuildContext context);
  Future<bool> checkIfNameExists(String name);
  Stream<List<EstablishmentModel>> getData();
}

class LocationrespositoryImpl implements Locationrespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This will add the location to the database
  @override
  Future<void> addLocation(Map<String, dynamic> locationData, BuildContext context) async {

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Adding Location...');

    final Function clearFields = locationData['ClearFields'];
    try {

      User user = _auth.currentUser!;
      String id = user.uid;

      QuerySnapshot userDoc = await _firestore.collection('Users').where('Uid', isEqualTo: id).get();
      if (userDoc.docs.isEmpty) {
        pd.close();
        return;
      }
      else{
        var name = userDoc.docs[0].get('Name');

        var shelterImage = locationData['Image'];

        // Upload image to firebase storage
        var uuid = Uuid();
        String uid = uuid.v4();

        Uint8List bytesIdFront = await File(shelterImage).readAsBytes();

        // Upload to Firebase Storage
        Reference shelterRef = FirebaseStorage.instance.ref().child('EstablishmentPicture/$uid.jpg');

        // Upload the image to firebase storage
        TaskSnapshot profileSnap = await shelterRef.putData(bytesIdFront);

        // Get the download url of the image
        String profileUrl = await profileSnap.ref.getDownloadURL();

        // Set the document with the specified ID
        await _firestore.collection('LocationCollection').doc(uid).set({
          'EstablishmentName': locationData['EstablishmentName'],
          'EstablishmentDescription': locationData['EstablishmentDescription'],
          'EstablishmentAddress': locationData['EstablishmentAddress'],
          'EstablishmentPhoneNumber': locationData['EstablishmentPhoneNumber'],
          'EstablishmentEmail': locationData['EstablishmentEmail'],
          'EstablishmentPicture': profileUrl,
          'EstablishmentLat': locationData['Longitude'],
          'EstablishmentLong': locationData['Latitude'],
          'EstablishmentType': locationData['EstablishmentType'],
          'EstablishmentOwnerID': id,
          'EstablishmentOwnerName': name,
          'EstablishmentStatus': 'Pending',
        });

        clearFields();

        ToastComponent().showMessage(Colors.green, 'Establishment added successfully');
      }

    } catch (e) {
      throw Exception(e);
    }
    finally {
      pd.close();
    }
  }

  // This will check if the name already exists in the database
  Future <bool> checkIfNameExists(String name) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('LocationCollection').where('EstablishmentName', isEqualTo: name).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception(e);
    }
  }

  // This will get the data from the database
  @override
  Stream<List<EstablishmentModel>> getData() {
    User user = _auth.currentUser!;

    return _firestore.collection('LocationCollection').
    where('EstablishmentOwnerID', isEqualTo: user.uid).snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EstablishmentModel.fromDocumentSnapshot(doc)).toList());
  }


}