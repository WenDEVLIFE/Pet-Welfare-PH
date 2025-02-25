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

  void updateLocation(Map<String, dynamic> data, BuildContext context);

  void deleteEstablishment(String id, BuildContext context);

  void updateProfileImage(String selectedImage, String id, BuildContext context);
}

class LocationrespositoryImpl implements Locationrespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

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
          'EstablishmentPictureUrl': profileUrl,
          'EstablishmentPicture': '$uid.jpg',
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

  // Update the data
  @override
  Future<void> updateLocation(Map<String, dynamic> data, BuildContext context) async {
    User user = _auth.currentUser!;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Updating Location...');

    // TODO : Fix the File not getting the location
    try {
         // get the id from the list
         var id = data['establishmentId'];

         DocumentSnapshot userDoc = await _firestore.collection('LocationCollection').doc(id).get();
         print('Existing document data: ${userDoc.data()}');
         if (userDoc.exists) {

           // Update Firestore with new data
           await _firestore.collection('LocationCollection').doc(id).update({
             'EstablishmentName': data['establishmentName'],
             'EstablishmentDescription': data['establishmentDescription'],
             'EstablishmentLat': data['lat'],
             'EstablishmentLong': data['long'],
             'EstablishmentAddress': data['establishmentAddress'],
             'EstablishmentPhoneNumber': data['establishmentPhoneNumber'],
             'EstablishmentEmail': data['establishmentEmail'],
             'EstablishmentType': data['EstablishmentType'],

           });
           ToastComponent().showMessage(Colors.green, 'Establishment updated successfully');

         }

    } catch (e) {
      throw Exception(e);
    }
    finally {
      pd.close();
    }
  }


  // This will delete the establishment
  Future <void> deleteEstablishment(String id, BuildContext context) async{

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Deleting Establishment...');
    try {
      DocumentSnapshot userDoc = await _firestore.collection('LocationCollection').doc(id).get();
      if (userDoc.exists) {
        // Get the stored Firebase Storage path, NOT the URL
        var storedPath = userDoc.get('EstablishmentPicture');

        // Reference to Firebase Storage
        Reference oldImageRef = FirebaseStorage.instance.ref().child('EstablishmentPicture/$storedPath');

        // Delete the old image
        try {
          await oldImageRef.delete();
          print('Old image deleted successfully.');
          // Delete the establishment
          await _firestore.collection('LocationCollection').doc(id).delete();
          ToastComponent().showMessage(Colors.green, 'Establishment deleted successfully');
        } catch (e) {
          print('Failed to delete old image: $e');
        }
      }
    }catch (e){
      throw Exception(e);
    }
    finally {
      pd.close();
    }
  }

  @override
  Future<void> updateProfileImage(String selectedImage, String id, BuildContext context) async {

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Updating Profile Image...');

    try{

      DocumentSnapshot userDoc = await _firestore.collection('LocationCollection').doc(id).get();
      if (userDoc.exists) {
        // Get the stored Firebase Storage path, NOT the URL
        var storedPath = userDoc.get('EstablishmentPicture');

        // Reference to Firebase Storage
        Reference oldImageRef = FirebaseStorage.instance.ref().child('EstablishmentPicture/$storedPath');

        // Delete the old image
        try {
          await oldImageRef.delete();
          print('Old image deleted successfully.');
        } catch (e) {
          print('Failed to delete old image: $e');
        }
        // Upload image to firebase storage
        Uint8List bytesIdFront = await File(selectedImage).readAsBytes();

        // Upload to Firebase Storage
        Reference shelterRef = FirebaseStorage.instance.ref().child('EstablishmentPicture/$id.jpg');

        // Upload the image to firebase storage
        TaskSnapshot profileSnap = await shelterRef.putData(bytesIdFront);

        // Get the download url of the image
        String profileUrl = await profileSnap.ref.getDownloadURL();

        // Set the document with the specified ID
        await _firestore.collection('LocationCollection').doc(id).update({
          'EstablishmentPictureUrl': profileUrl,
          'EstablishmentPicture': '$id.jpg',
        });

        ToastComponent().showMessage(Colors.green, 'Profile image updated successfully');
      }

    } catch (e) {
      throw Exception(e);
    }
    finally {
      pd.close();
    }
  }

}