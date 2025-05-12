import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {

  final String id;

  final String donationname;
  final String donationType;

  final String amount;

  final String time;

  final String purposeOfDonation;

  final String transactionPath;



  DonationModel ({
    required this.id,
    required this.donationname,
    required this.donationType,
    required this.amount,
    required this.time,
    required this.purposeOfDonation,
    required this.transactionPath,
  });

  factory DonationModel.fromDocumentSnapshot(
      DocumentSnapshot doc) {
    return DonationModel(
      id: doc.id,
      donationname: doc['DonatorName'] ?? '',
      donationType: doc['DonationType'] ?? '',
      amount: doc['Amount'] ?? '',
      time: doc['Time'] ?? '',
      purposeOfDonation: doc['DonationType'] ?? '',
      transactionPath: doc['TransactionPath'] ?? '',
    );
  }
}