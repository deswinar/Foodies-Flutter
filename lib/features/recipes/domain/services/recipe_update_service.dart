import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/injection/service_locator.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../data/model/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeUpdateService {
  // final _cloudinaryService = getIt<CloudinaryService>();

  Future<Recipe> updateRecipe({
    required Recipe oldRecipe,
    required String title,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    required List<String> tags,
    required List<dynamic> newImages,
    required dynamic newThumbnail,
    required String? youtubeVideoUrl,
    required String category,
    required String country,
    required String portion,
    required String cookingDuration,
    required List<String> imagesToDelete,
    required List<String> imagesToAdd,
  }) async {
    final user = getIt<FirebaseAuth>().currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final cloudinaryService = getIt<CloudinaryService>();

    List<String> finalImageUrls = [];

    print("Old images: ${oldRecipe.imageUrls}");
    print("imagesToAdd: $imagesToAdd");
    print("imagesToDelete: $imagesToDelete");

    try {
      // Process new and existing images
      for (final image in newImages) {
        if (image is File) {
          final imageUrl = await cloudinaryService.uploadImage(image);
          finalImageUrls.add(imageUrl);
        } else if (image is String) {
          finalImageUrls.add(image);
        } else {
          throw Exception('Unsupported image type');
        }
      }

      // Deduplicate `finalImageUrls`
      finalImageUrls = finalImageUrls.toSet().toList();

      print("Final image URLs to save: $finalImageUrls");
      print("Removed images: $imagesToDelete");

      // Delete removed images from Cloudinary
      if (imagesToDelete.isNotEmpty) {
        final publicIds =
            imagesToDelete.map(cloudinaryService.extractPublicId).toList();
        await cloudinaryService.deleteImages(publicIds);
      }
    } catch (e) {
      throw Exception('Image processing failed: ${e.toString()}');
    }

    // Prepare updated recipe
    final updatedRecipe = oldRecipe.copyWith(
      title: title,
      description: description,
      imageUrls: finalImageUrls,
      thumbnailUrl: newThumbnail,
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

    return updatedRecipe;
  }
}
