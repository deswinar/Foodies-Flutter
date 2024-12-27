import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/recipes/data/model/recipe_model.dart';
import '../../../injection/service_locator.dart';
import '../../user_profiles/data/model/user_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final FirebaseAuth auth = getIt<FirebaseAuth>();

  FavoriteRepository();

  Future<List<Recipe>> fetchUserFavorites({int limit = 5}) async {
    try {
      // Ensure the user is logged in
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      // Fetch recipeIds from 'likes' subcollection for the current user
      final likesQuerySnapshot = await _firestore
          .collectionGroup('likes')
          .where('userId', isEqualTo: user.uid)
          .limit(limit)
          .get();

      // Extract recipeIds from the likes documents
      final likedRecipeIds = likesQuerySnapshot.docs
          .map((doc) => doc.reference.parent.parent?.id) // Get parent recipeId
          .whereType<String>() // Remove nulls if any
          .toList();

      if (likedRecipeIds.isEmpty) {
        return []; // No liked recipes
      }

      // Fetch the liked recipes using the recipeIds
      final recipeQuerySnapshot = await _firestore
          .collection('recipes')
          .where(FieldPath.documentId,
              whereIn:
                  likedRecipeIds) // Use the likedRecipeIds to fetch recipes
          .get();

      // Extract userIds from the fetched recipes
      final userIds = recipeQuerySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['userId'] as String?)
          .where((userId) => userId != null) // Filter out null userIds
          .toSet() // Remove duplicates
          .toList();

      // If no userIds, return recipes without user data
      if (userIds.isEmpty) {
        return recipeQuerySnapshot.docs.map((doc) {
          final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(id: doc.id);
          return recipe;
        }).toList();
      }

      // Fetch users associated with the userIds
      final userQuerySnapshot = await _firestore
          .collection('users')
          .where('uid', whereIn: userIds) // Corrected from userId to uid
          .get();

      // Create a map of userId to UserModel
      final usersMap = {
        for (var doc in userQuerySnapshot.docs)
          doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      // Attach user data to the corresponding recipe
      return recipeQuerySnapshot.docs.map((doc) {
        final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);

        // Find the user corresponding to this recipe
        final user = usersMap[recipe.userId];
        if (user != null) {
          return recipe.copyWith(user: user);
        }

        return recipe; // If no user found, return recipe as is
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite recipes: $e');
    }
  }
}
