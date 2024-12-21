import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/injection/service_locator.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../data/model/recipe_model.dart';

class RecipeUpdateService {
  final _cloudinaryService = getIt<CloudinaryService>();

  Future<Recipe> updateRecipe({
    required Recipe oldRecipe,
    required String title,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    required List<String> tags,
    required List<dynamic>
        newImages, // Mixed: File (new) or String (existing URL)
    required dynamic newThumbnail, // Mixed: File (new) or String (existing URL)
    required String? youtubeVideoUrl,
    required String category,
    required String country,
    required String portion,
    required String cookingDuration,
  }) async {
    final user = getIt<FirebaseAuth>().currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Prepare lists for image URLs
    List<String> imageUrls = [];
    String? thumbnailUrl;

    try {
      // Process images: if File, upload; if String, reuse URL
      for (final image in newImages) {
        if (image is File) {
          final imageUrl = await _cloudinaryService.uploadImage(image);
          imageUrls.add(imageUrl);
        } else if (image is String) {
          imageUrls.add(image); // Retain existing URL
        } else {
          throw Exception('Unsupported image type');
        }
      }

      // Process thumbnail: if File, upload; if String, reuse URL
      if (newThumbnail is File) {
        thumbnailUrl = await _cloudinaryService.uploadImage(newThumbnail);
      } else if (newThumbnail is String) {
        thumbnailUrl = newThumbnail; // Retain existing URL
      }
    } catch (e) {
      throw Exception('Image upload failed: ${e.toString()}');
    }

    // Prepare the updated recipe
    final updatedRecipe = oldRecipe.copyWith(
      title: title,
      description: description,
      imageUrls: imageUrls,
      thumbnailUrl: thumbnailUrl,
      youtubeVideoUrl: youtubeVideoUrl,
      ingredients: ingredients,
      steps: steps,
      tags: tags,
      category: category,
      country: country,
      portion: portion,
      cookingDuration: cookingDuration,
      updatedAt: DateTime.now(),
    );
    print(thumbnailUrl);

    return updatedRecipe;
  }
}
