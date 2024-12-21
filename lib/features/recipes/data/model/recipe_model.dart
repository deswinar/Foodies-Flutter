import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../user_profiles/data/model/user_model.dart'; // Import your UserModel

class Recipe {
  final String id; // Unique identifier for the recipe
  final String userId; // ID of the user who created the recipe
  final String title; // Recipe title
  final String description; // Detailed recipe description
  final List<String> imageUrls; // List of URLs for all recipe images
  final String thumbnailUrl; // URL of the chosen thumbnail image
  final String? youtubeVideoUrl; // Optional YouTube video URL for tutorial
  final List<String> ingredients; // List of ingredients
  final List<String> steps; // Step-by-step instructions
  final List<String> tags; // Recipe categories or tags
  final int commentsCount; // Number of comments on the recipe
  final int shareCount; // Number of times the recipe has been shared
  final DateTime createdAt; // Timestamp for recipe creation
  final int likesCount; // Total number of likes
  final String category; // Recipe category
  final String country; // Country of origin
  final String portion; // Number of servings or portions
  final String cookingDuration; // Estimated cooking time
  final UserModel? user; // Optional user model for recipe creator
  final DateTime? updatedAt;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.thumbnailUrl,
    this.youtubeVideoUrl,
    required this.ingredients,
    required this.steps,
    required this.tags,
    required this.commentsCount,
    required this.shareCount,
    required this.createdAt,
    required this.likesCount,
    required this.category,
    required this.portion,
    required this.cookingDuration,
    required this.country,
    this.user, // Optional user model
    this.updatedAt,
  });

  // CopyWith Method
  Recipe copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? thumbnailUrl,
    String? youtubeVideoUrl,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? tags,
    int? commentsCount,
    int? shareCount,
    DateTime? createdAt,
    int? likesCount,
    String? category,
    String? portion,
    String? cookingDuration,
    String? country,
    UserModel? user, // Include user model
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      youtubeVideoUrl: youtubeVideoUrl ?? this.youtubeVideoUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
      commentsCount: commentsCount ?? this.commentsCount,
      shareCount: shareCount ?? this.shareCount,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      category: category ?? this.category,
      portion: portion ?? this.portion,
      cookingDuration: cookingDuration ?? this.cookingDuration,
      country: country ?? this.country,
      user: user ?? this.user, // Assign user model
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // fromMap and toMap for Firestore integration
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      youtubeVideoUrl: map['youtubeVideoUrl'],
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
      shareCount: map['shareCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likesCount: map['likesCount'] ?? 0,
      category: map['category'] ?? '',
      portion: map['portion'] ?? '',
      cookingDuration: map['cookingDuration'] ?? '',
      country: map['country'] ?? '',
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null, // Parse user model
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'thumbnailUrl': thumbnailUrl,
      'youtubeVideoUrl': youtubeVideoUrl,
      'ingredients': ingredients,
      'steps': steps,
      'tags': tags,
      'commentsCount': commentsCount,
      'shareCount': shareCount,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'category': category,
      'portion': portion,
      'cookingDuration': cookingDuration,
      'country': country,
      'user': user?.toMap(), // Convert user model to map
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
    };
  }
}

class Comment {
  final String recipeId;
  final String userId;
  final String comment;
  final DateTime createdAt;
  final String displayName;
  final String photoURL;

  Comment({
    required this.recipeId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.displayName,
    required this.photoURL,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      recipeId: map['recipeId'] ?? '',
      userId: map['userId'] ?? '',
      comment: map['comment'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
