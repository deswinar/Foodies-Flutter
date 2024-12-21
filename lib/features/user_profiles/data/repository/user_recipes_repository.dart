import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../recipes/data/model/recipe_model.dart';
import '../../../../injection/service_locator.dart';
import '../model/user_model.dart';

class UserRecipeRepository {
  final FirebaseFirestore firestore = getIt<FirebaseFirestore>();
  final FirebaseAuth auth = getIt<FirebaseAuth>();

  UserRecipeRepository();

  /// Fetch user recipes with pagination support
  Future<List<Recipe>> fetchUserRecipes({
    required UserModel userModel,
    DocumentSnapshot? lastDocument, // For pagination
    int limit = 5, // Number of recipes to fetch per page
  }) async {
    try {
      // Ensure the user is logged in
      final user = userModel;
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      // Build the query to fetch recipes created by the current user
      Query query = firestore
          .collection('recipes')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Apply pagination if `lastDocument` is provided
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Execute the query
      final querySnapshot = await query.get();

      // Extract userId from the fetched recipes
      final userIds = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['userId'] as String?)
          .where((userId) => userId != null) // Filter out null userIds
          .toSet() // Remove duplicates
          .toList();

      // If no userIds, return recipes without user data
      if (userIds.isEmpty) {
        return querySnapshot.docs.map((doc) {
          final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(id: doc.id);
          return recipe;
        }).toList();
      }

      // Fetch the user associated with the userId
      final userQuerySnapshot = await firestore
          .collection('users')
          .where('uid', whereIn: userIds) // Corrected from userId to uid
          .get();

      // Create a map of userId to UserModel
      final usersMap = {
        for (var doc in userQuerySnapshot.docs)
          doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      // Attach user data to the corresponding recipe
      return querySnapshot.docs.map((doc) {
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
      print('Error fetching user recipes: $e');
      throw Exception('Failed to fetch user recipes.');
    }
  }
}
