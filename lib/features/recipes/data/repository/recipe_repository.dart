import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/recipes/data/model/recipe_model.dart';

import '../../../../core/services/cloudinary_service.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/services/recipe_update_service.dart';

class RecipeRepository {
  final FirebaseFirestore firestore;

  RecipeRepository({required this.firestore});

  /// Adds a recipe to Firestore and returns its generated document ID.
  Future<Recipe> addRecipe(Recipe recipe) async {
    // Add recipe to Firestore and get the document reference
    final docRef = await firestore.collection('recipes').add(recipe.toMap());

    // Fetch the added recipe using the document ID
    final addedRecipeSnapshot = await docRef.get();

    // Convert the document snapshot to a Recipe object (you can adjust this based on your Recipe model)
    final addedRecipe = Recipe.fromMap({
      ...addedRecipeSnapshot.data()!,
      'id': docRef.id, // Add the generated document ID to the map
    });

    // Return the created Recipe object with ID
    return addedRecipe;
  }

  /// Fetches a recipe by its ID. Returns `null` if the recipe is not found.
  Future<Recipe?> getRecipeById(String recipeId) async {
    try {
      final docSnapshot =
          await firestore.collection('recipes').doc(recipeId).get();
      if (!docSnapshot.exists) return null;

      return Recipe.fromMap(docSnapshot.data() as Map<String, dynamic>)
          .copyWith(id: docSnapshot.id);
    } catch (e) {
      throw Exception('Failed to fetch recipe: $e');
    }
  }

  /// Updates an existing recipe in Firestore.
  Future<Recipe> updateRecipe(
      Recipe oldRecipe, Recipe newRecipe, List<XFile> imagesToAdd) async {
    final cloudinaryService = getIt<CloudinaryService>();
    List<String> _uploadedImageUrls = [];

    for (final image in imagesToAdd) {
      print(image.toString());
      if (image is XFile) {
        final imageUrl = await cloudinaryService.uploadImage(File(image.path));
        _uploadedImageUrls.add(imageUrl);
      } else {
        throw Exception('Unsupported image type');
      }
    }

    final List<String> newImageUrls = [
      ...oldRecipe.imageUrls,
      ..._uploadedImageUrls
    ];
    newRecipe.copyWith(imageUrls: newImageUrls);

    Map<String, dynamic> newRecipeMap = newRecipe.toMap();

    // Remove the sensitive attribute
    newRecipeMap.remove('newImageFiles');

    final docRef = firestore.collection('recipes').doc(oldRecipe.id);
    await docRef.update(newRecipeMap);
    // await docRef.update({
    //     'imageUrls': FieldValue.arrayUnion(imagesToAdd),
    //   });
    // await docRef.update({
    //     'imageUrls': FieldValue.arrayRemove(imagesToDelete),
    //   });

    final updatedRecipeSnapshot = await docRef.get();
    return Recipe.fromMap(updatedRecipeSnapshot.data() as Map<String, dynamic>)
        .copyWith(id: updatedRecipeSnapshot.id);
  }

  /// Updates an existing recipe in Firestore.
  Future<void> updateRecipe2(Recipe recipe) async {
    await firestore.collection('recipes').doc(recipe.id).update(recipe.toMap());
  }

  /// Deletes a recipe from Firestore using its ID.
  Future<void> deleteRecipe(String id) async {
    await firestore.collection('recipes').doc(id).delete();
  }

  /// Fetches all recipes from Firestore.
  Future<List<Recipe>> getAllRecipes() async {
    final querySnapshot = await firestore.collection('recipes').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Attach document ID
      return Recipe.fromMap(data);
    }).toList();
  }

  /// Fetches all recipes created by a specific user.
  Future<List<Recipe>> getRecipesByUserId(String userId) async {
    final querySnapshot = await firestore
        .collection('recipes')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Attach document ID
      return Recipe.fromMap(data);
    }).toList();
  }
}
