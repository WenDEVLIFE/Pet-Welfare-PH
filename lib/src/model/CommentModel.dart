import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentModel {
  final String commendID;
  final String userid;
  final String profileUrl;
  final String Name;
  final String commentText;
  final String formattedTimestamp;

  CommentModel({
    required this.commendID,
    required this.profileUrl,
    required this.Name,
    required this.commentText,
    required this.userid,
    required this.formattedTimestamp,
  });

  static Future<CommentModel> fromDocument(DocumentSnapshot doc) async {
    String userId = doc['UserId'];
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    Timestamp timestamp = doc['Timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return CommentModel(
      commendID: doc.id,
      profileUrl: userDoc['ProfileUrl'],
      Name: userDoc['Name'],
      commentText: doc['CommentText'],
      userid: userId,
      formattedTimestamp: formattedTimestamp,
    );
  }
}