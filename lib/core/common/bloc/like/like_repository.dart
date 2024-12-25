import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../injection/service_locator.dart';

class LikeRepository {
  final FirebaseFirestore firestore;
  final user = getIt<FirebaseAuth>().currentUser;

  LikeRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches the list of liked recipes for the current user
  Future<List<String>> fetchLikedRecipes() async {
    try {
      final snapshot = await firestore
          .collectionGroup('likes') // Search across all likes sub-collections
          .where('userId', isEqualTo: user!.uid)
          .get();

      return snapshot.docs
          .map((doc) => doc.reference.parent.parent?.id ?? '') // Extract recipeId
          .where((recipeId) => recipeId.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch liked recipes: $e');
    }
  }

  /// Toggles the like status for a specific recipe
  Future<void> toggleLike(String recipeId) async {
    try {
      final likeDoc = firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('likes')
          .doc(user!.uid); // Use userId as the document ID for easy checks

      final docSnapshot = await likeDoc.get();

      if (docSnapshot.exists) {
        // Unlike the recipe
        await likeDoc.delete();

        // Decrement the like count in the Recipe document
        await firestore
            .collection('recipes')
            .doc(recipeId)
            .update({'likesCount': FieldValue.increment(-1)});
      } else {
        // Like the recipe
        await likeDoc.set({
          'userId': user!.uid,
          'likedAt': FieldValue.serverTimestamp(),
        });

        // Increment the like count in the Recipe document
        await firestore
            .collection('recipes')
            .doc(recipeId)
            .update({'likesCount': FieldValue.increment(1)});
      }
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  /// Checks if the current user has liked a specific recipe
  Future<bool> isLiked(String recipeId) async {
    try {
      final likeDoc = firestore
          .collection('recipes')
          .doc(recipeId)
          .collection('likes')
          .doc(user!.uid);

      final docSnapshot = await likeDoc.get();
      return docSnapshot.exists;
    } catch (e) {
      throw Exception('Failed to check like status: $e');
    }
  }

  /// Fetches the like count for a specific recipe
  Future<int> likeCount(String recipeId) async {
    try {
      final recipeDoc =
          await firestore.collection('recipes').doc(recipeId).get();

      if (recipeDoc.exists) {
        return recipeDoc['likesCount'] ?? 0;
      }

      return 0;
    } catch (e) {
      throw Exception('Failed to fetch like count: $e');
    }
  }
}
