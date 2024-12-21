import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/injection/service_locator.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../data/model/recipe_model.dart';
import '../recipe/recipe_bloc.dart';

class RecipeSubmissionService {
  final _cloudinaryService = getIt<CloudinaryService>();

  Future<void> submitRecipe({
    required String title,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    required List<String> tags,
    required List<File> uploadedImages,
    required File? thumbnailImage,
    required String? youtubeVideoUrl,
    required String category, // New parameter
    required String country, // New parameter
    required String portion, // New parameter
    required String cookingDuration, // New parameter
  }) async {
    // Get the currently logged-in user
    final user = getIt<FirebaseAuth>().currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    // Upload images to Cloudinary and retrieve their URLs
    List<String> imageUrls = [];
    String? thumbnailUrl;

    try {
      // Upload all provided images
      for (final image in uploadedImages) {
        final imageUrl = await _cloudinaryService.uploadImage(image);
        imageUrls.add(imageUrl);
      }

      // Upload thumbnail image if provided
      if (thumbnailImage != null) {
        thumbnailUrl = await _cloudinaryService.uploadImage(thumbnailImage);
      }
    } catch (e) {
      throw Exception('Image upload failed: ${e.toString()}');
    }

    // Prepare the recipe object with user information
    final recipe = Recipe(
      id: '', // Firestore will generate this
      userId: user.uid,
      title: title,
      description: description,
      imageUrls: imageUrls,
      thumbnailUrl: thumbnailUrl ?? '',
      youtubeVideoUrl: youtubeVideoUrl,
      ingredients: ingredients,
      steps: steps,
      tags: tags,
      category: category, // New field
      country: country, // New field
      portion: portion, // New field
      cookingDuration: cookingDuration, // New field
      likesCount: 0,
      commentsCount: 0,
      shareCount: 0,
      createdAt: DateTime.now(),
    );

    // Access the RecipeBloc using GetIt and add the recipe event
    final recipeBloc = GetIt.instance<RecipeBloc>();
    recipeBloc.add(AddRecipeEvent(recipe: recipe));
  }
}
