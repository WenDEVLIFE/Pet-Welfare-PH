import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

abstract class AdoptionRepository {
  Future <void> submitAdoptionForm(Map<String, String> applyForm, Function clearForm);

}

class AdoptionRepositoryImpl implements AdoptionRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit Adoption Form
  @override
  Future<void> submitAdoptionForm(Map<String, dynamic> applyForm, Function clearForm) async {
    User? user = _firebaseAuth.currentUser;
    String? uid = user!.uid;
    String postID = applyForm['postId'];

    QuerySnapshot querySnapshot = await _firestore.collection('PostCollection').doc(postID).collection('AdoptionForm').where('Uid', isEqualTo: uid)
       .where('PostID', isEqualTo: postID).get();

    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('You have already submitted an application for this pet');
    }

    await _firestore.collection('PostCollection').doc(postID).collection('AdoptionForm').add({
      'Uid': uid,
      'PostID': postID,
      'Name': applyForm['name'],
      'Email': applyForm['email'],
       'FacebookUsername': applyForm['facebookUsername'],
      'Phone': applyForm['phone'],
      'Address': applyForm['address'],
      'AdoptionType': applyForm['adoptionType'],
      'Region': applyForm['region'],
      'Province': applyForm['province'],
      'City': applyForm['city'],
      'Barangay': applyForm['barangay'],
      'Status': 'Still up for adoption',
      'CreatedAt': FieldValue.serverTimestamp(),
        });

    clearForm();
    ToastComponent().showMessage(Colors.green, 'Adoption form submitted successfully');
  }

}