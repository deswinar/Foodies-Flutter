import 'package:cloud_firestore/cloud_firestore.dart';

class Following {
  final String userId; // ID of the user being followed
  final DateTime followedAt; // Timestamp for when the follow occurred

  Following({
    required this.userId,
    required this.followedAt,
  });

  factory Following.fromMap(Map<String, dynamic> map) {
    return Following(
      userId: map['userId'] ?? '',
      followedAt: (map['followedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'followedAt': followedAt,
    };
  }
}
