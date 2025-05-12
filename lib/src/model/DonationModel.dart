import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {

  final String id;

  final String accountNumber;

  final String bankName;

  final String bankHolder;

  final String donationType;

  final String amount;

  final String purposeOfDonation;



  DonationModel ({
    required this.id,
    required this.accountNumber,
    required this.bankName,
    required this.bankHolder,
    required this.donationType,
    required this.amount,
    required this.purposeOfDonation,
  });

  factory DonationModel.fromDocumentSnapshot(
      DocumentSnapshot doc) {
    return DonationModel(
      id: doc.id,
      accountNumber: doc['AccountNumber'],
      bankName: doc['BankName'],
      bankHolder: doc['BankHolder'],
      donationType: doc['DonationType'],
      amount: doc['EstimatedAmount'],
      purposeOfDonation: doc['PurposeOfDonation'],
    );
  }
}