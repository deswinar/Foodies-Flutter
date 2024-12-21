import 'package:cloud_firestore/cloud_firestore.dart';

class Follower {
  final String userId; // ID of the user who is following
  final DateTime followedAt; // Timestamp for when the follow occurred

  Follower({
    required this.userId,
    required this.followedAt,
  });

  factory Follower.fromMap(Map<String, dynamic> map) {
    return Follower(
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
