import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String comment;
  final String profilePictureUrl;
  final int rating;
  final DateTime timestamp;
  final String userName;

  Review({
    required this.comment,
    required this.profilePictureUrl,
    required this.rating,
    required this.timestamp,
    required this.userName,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      comment: map['comment'],
      profilePictureUrl: map['profile_picture_url'],
      rating: map['rating'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userName: map['user_name'],
    );
  }
}
