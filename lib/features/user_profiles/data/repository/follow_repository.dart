// lib/features/following/data/repositories/following_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../injection/service_locator.dart';
import '../model/follower_model.dart';
import '../model/following_model.dart';
import '../model/user_model.dart';

class FollowRepository {
  final FirebaseFirestore _firebaseFirestore;
  final user = getIt<FirebaseAuth>().currentUser;

  FollowRepository({required FirebaseFirestore firestore})
      : _firebaseFirestore = firestore;

  // Follow a user
  Future<void> followUser(String creatorId) async {
    try {
      final followedAt = DateTime.now();

      // Add to the user's following subcollection
      await _firebaseFirestore
          .collection('users') // Collection of users
          .doc(user!.uid) // Current user's document
          .collection('followings') // Following subcollection
          .doc(creatorId) // The creator being followed
          .set({
        'creatorId': creatorId,
        'followingAt': followedAt,
      });

      // Add to the creator's followers subcollection
      await _firebaseFirestore
          .collection('users') // Collection of users
          .doc(creatorId) // Creator's document
          .collection('followers') // Followers subcollection
          .doc(user!.uid) // The user who is following
          .set({
        'userId': user!.uid,
        'followedAt': followedAt,
      });
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(String creatorId) async {
    try {
      // Remove from the user's following subcollection
      await _firebaseFirestore
          .collection('users') // Collection of users
          .doc(user!.uid) // Current user's document
          .collection('followings') // Following subcollection
          .doc(creatorId) // The creator being unfollowed
          .delete();

      // Remove from the creator's followers subcollection
      await _firebaseFirestore
          .collection('users') // Collection of users
          .doc(creatorId) // Creator's document
          .collection('followers') // Followers subcollection
          .doc(user!.uid) // The user who is unfollowing
          .delete();
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  // Check if the user is following the creator
  Future<bool> isFollowing(String creatorId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('users') // Collection of users
          .doc(user!.uid) // Current user's document
          .collection('followings') // Following subcollection
          .where('creatorId', isEqualTo: creatorId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check follow status: $e');
    }
  }

  // Optionally, you can also add methods to fetch followings or followers
  Future<List<UserModel>> fetchFollowings(String userId,
      {int limit = 10, String? startAfter}) async {
    try {
      Query query = _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('followings')
          .orderBy('followingAt')
          .limit(limit);

      if (startAfter != null) {
        final startAfterDoc = await _firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('followings')
            .doc(startAfter)
            .get();
        query = query.startAfterDocument(startAfterDoc);
      }

      final querySnapshot = await query.get();

      final followingIds = querySnapshot.docs.map((doc) => doc.id).toList();

      if (followingIds.isEmpty) return [];

      final userQuerySnapshot = await _firebaseFirestore
          .collection('users')
          .where('uid', whereIn: followingIds)
          .get();

      return userQuerySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch following: $e');
    }
  }

  Future<int> countFollowings(String userId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('followings')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to count followings: $e');
    }
  }

  Future<List<UserModel>> fetchFollowers(String userId,
      {int limit = 10, String? startAfter}) async {
    try {
      Query query = _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('followers')
          .orderBy('followedAt')
          .limit(limit);

      if (startAfter != null) {
        final startAfterDoc = await _firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('followers')
            .doc(startAfter)
            .get();
        query = query.startAfterDocument(startAfterDoc);
      }

      final querySnapshot = await query.get();

      final followerIds = querySnapshot.docs.map((doc) => doc.id).toList();

      if (followerIds.isEmpty) return [];

      final userQuerySnapshot = await _firebaseFirestore
          .collection('users')
          .where('uid', whereIn: followerIds)
          .get();

      return userQuerySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch followers: $e');
    }
  }

  Future<int> countFollowers(String userId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to count followers: $e');
    }
  }
}
