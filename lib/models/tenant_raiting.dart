import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  String uid;
  String displayName;
  String feedback;
  String date;
  int rating;

  RatingModel({
    required this.uid,
    required this.displayName,
    required this.feedback,
    required this.date,
    required this.rating,
  });

  Map<String, dynamic> getFeedback() {
    return {
      'uid': uid,
      'displayName': displayName,
      'feedback': feedback,
      'date': date,
      'rating': rating,
    };
  }

  Future<void> storeRating(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('tenant_ratings').add(data);
  }
}
