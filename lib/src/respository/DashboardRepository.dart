import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DashboardRepository {

  Future <int> getTotalUsers();

  Future <int> getTotalPosts();

  Future <int> getVerifiedUsers();

  Future <int> getUnverifiedUsers();

  Future <int> getBannedUsers();
}

class DashboardRepositoryImpl implements DashboardRepository {

  Future <int> getTotalUsers() async {

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();
    print("Documents: ${snapshot.docs}");
    if (snapshot.docs.isEmpty) {
      return 0; // No users found
    } else {
      return snapshot.docs.length; // Return the count of users
    }
  }

  Future <int> getTotalPosts() async {

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('PostCollection').get();
    print("Documents: ${snapshot.docs}");
    if (snapshot.docs.isEmpty) {
      return 0; // No posts found
    } else {
      return snapshot.docs.length; // Return the count of posts
    }
  }

  Future<int> getVerifiedUsers() async {
     QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Status', isEqualTo: "Approved")
        .get();
     print("Documents: ${snapshot.docs}");
    if (snapshot.docs.isEmpty) {
      return 0; // No verified users found
    } else {
      return snapshot.docs.length; // Return the count of verified users
    }
  }

  Future <int> getUnverifiedUsers() async {

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Status', isEqualTo: "Pending")
        .get();
    print("Documents: ${snapshot.docs}");
    if (snapshot.docs.isEmpty) {
      return 0; // No unverified users found
    } else {
      return snapshot.docs.length; // Return the count of unverified users
    }
  }

  Future <int> getBannedUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Status', isEqualTo: "Banned")
        .get();
    print("Documents: ${snapshot.docs}");
    if (snapshot.docs.isEmpty) {
      return 0; // No banned users found
    } else {
      return snapshot.docs.length; // Return the count of banned users
    }
  }

}