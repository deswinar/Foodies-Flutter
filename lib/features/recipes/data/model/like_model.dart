import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  final String userId; // ID of the user who liked the recipe
  final String recipeId;
  final String displayName; // displayName of the user
  final String photoURL; // Profile picture URL of the user
  final DateTime likedAt; // Timestamp for when the like occurred

  Like({
    required this.userId,
    required this.recipeId,
    required this.displayName,
    required this.photoURL,
    required this.likedAt,
  });

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      userId: map['userId'] ?? '',
      recipeId: map['recipeId'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
      likedAt: (map['likedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'recipeId': recipeId,
      'displayName': displayName,
      'photoURL': photoURL,
      'likedAt': likedAt,
    };
  }
}
