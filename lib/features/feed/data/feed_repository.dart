import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/data/auth_repository.dart';
import '../../recipes/data/model/recipe_model.dart';
import '../../user_profiles/data/model/user_model.dart';

class PaginatedResult {
  final List<Recipe> recipes;
  final bool hasMore;

  PaginatedResult({required this.recipes, required this.hasMore});
}

class FeedRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  FeedRepository(this._firestore, this._authRepository);

  // Get current user ID from AuthRepository
  User? get user => _authRepository.getCurrentUser();

  // Fetch recipes from Firestore
  Future<List<Recipe>> fetchRecipes({
    int limit = 2,
    String? startAfter,
    String? category, // Optional category
    String? sortBy, // Sort criteria: 'createdAt', 'likesCount', etc.
    bool descending = true, // If true, order by descending, otherwise ascending
  }) async {
    try {
      Query query = _firestore.collection('recipes').limit(limit);

      // Sort by the provided field
      if (sortBy != null && sortBy.isNotEmpty) {
        if (sortBy == 'createdAt') {
          query = query.orderBy('createdAt', descending: descending);
        } else if (sortBy == 'likesCount') {
          query = query.orderBy('likesCount', descending: descending);
        } else if (sortBy == 'title') {
          query = query.orderBy('title', descending: descending);
        } else {
          throw Exception('Unsupported sort field: $sortBy');
        }
      } else {
        // Default sorting by 'createdAt' if no sortBy provided
        query = query.orderBy('createdAt', descending: descending);
      }

      if (startAfter != null) {
        final startAfterDoc =
            await _firestore.collection('recipes').doc(startAfter).get();
        query = query.startAfterDocument(startAfterDoc);
      }

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      // Fetch the recipe documents
      final querySnapshot = await query.get();

      // Get the list of userIds from the fetched recipes
      final userIds = querySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['userId'] as String?)
          .where((userId) => userId != null) // Filter out null userIds
          .toSet() // Remove duplicates
          .toList();

      // If userIds is empty, skip the user query
      if (userIds.isEmpty) {
        return querySnapshot.docs.map((doc) {
          final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
              .copyWith(id: doc.id);
          return recipe;
        }).toList();
      }

      // Fetch all users in a single query using 'whereIn' (only if userIds is not empty)
      final userQuerySnapshot = await _firestore
          .collection('users')
          .where('uid', whereIn: userIds) // Corrected from userId to uid
          .get();

      // Create a map of userId to UserModel using a for element
      final usersMap = {
        for (var doc in userQuerySnapshot.docs)
          doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      // Map each recipe with its corresponding user data
      return querySnapshot.docs.map((doc) {
        final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);

        // Attach user data to the recipe (if available)
        final user = usersMap[recipe.userId];
        if (user != null) {
          return recipe.copyWith(user: user);
        }

        return recipe; // If no user found, return recipe as is
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recipes: $e');
    }
  }

  // Fetch a single recipe by ID
  Future<Recipe?> getRecipeById(String recipeId) async {
    try {
      final docSnapshot =
          await _firestore.collection('recipes').doc(recipeId).get();
      if (!docSnapshot.exists) return null;

      return Recipe.fromMap(docSnapshot.data() as Map<String, dynamic>)
          .copyWith(id: docSnapshot.id);
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    try {
      await _firestore
          .collection('recipes')
          .doc(recipe.id)
          .update(recipe.toMap());
      // Fetch the updated document from Firestore
      final updatedSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipe.id)
          .get();

      // Convert the updated document back to a Recipe instance
      return Recipe.fromMap(updatedSnapshot.data()!);
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  // Fetch trending recipes based on likes/views
  Future<List<Recipe>> fetchTrendingRecipes({int limit = 5}) async {
    try {
      // Fetch trending recipes sorted by likesCount
      final querySnapshot = await _firestore
          .collection('recipes')
          .orderBy('likesCount', descending: true)
          .limit(limit)
          .get();

      // Extract userIds from the recipe documents
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
      throw Exception('Failed to fetch trending recipes: $e');
    }
  }

  DocumentSnapshot? _lastDocument; // Holds the last snapshot for pagination
  bool _hasMore = true; // Indicates whether more data is available

  // Search feeds by title
  Future<List<Recipe>> searchFeeds({
    required String searchTerm,
    int limit = 10,
    bool isInitialLoad = false,
  }) async {
    try {
      if (isInitialLoad) {
        _lastDocument = null;
        _hasMore = true;
      }

      if (!_hasMore) return [];

      // Perform title-based range query
      final query = _firestore
          .collection('recipes')
          .where('title', isGreaterThanOrEqualTo: searchTerm)
          .where('title', isLessThanOrEqualTo: '$searchTerm\uf8ff') // Unicode wildcard for prefix matching
          .orderBy('title')
          .limit(limit);

      // Apply pagination if a previous document exists
      final querySnapshot = _lastDocument != null
          ? await query.startAfterDocument(_lastDocument!).get()
          : await query.get();

      // Get the list of userIds from the fetched recipes
      final userIds = querySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['userId'] as String?)
          .where((userId) => userId != null) // Filter out null userIds
          .toSet() // Remove duplicates
          .toList();

      // If userIds is not empty, fetch users
      Map<String, UserModel> usersMap = {};
      if (userIds.isNotEmpty) {
        final userQuerySnapshot = await _firestore
            .collection('users')
            .where('uid', whereIn: userIds) // Corrected from userId to uid
            .get();

        // Create a map of userId to UserModel
        usersMap = {
          for (var doc in userQuerySnapshot.docs)
            doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
        };
      }

      // Map each recipe with its corresponding user data
      final recipes = querySnapshot.docs.map((doc) {
        final recipe = Recipe.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);

        // Attach user data to the recipe (if available)
        final user = usersMap[recipe.userId];
        if (user != null) {
          return recipe.copyWith(user: user);
        }

        return recipe; // If no user found, return recipe as is
      }).toList();

      // Update pagination state
      _lastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      _hasMore = querySnapshot.docs.length == limit;

      return recipes;
    } catch (e) {
      throw Exception('Failed to search feeds by title: $e');
    }
  }

  // Check if more data is available
  bool hasMore() => _hasMore;
}
