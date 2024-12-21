// lib/features/user_profiles/data/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid; // Unique identifier for the user
  final String email; // User's email
  final String? displayName; // User's display name
  final String? photoURL; // URL of the user's profile picture
  final DateTime? createdAt; // Timestamp when the user was created

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.createdAt,
  });

  /// Convert UserModel to Firestore document (Map<String, dynamic>)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
