// Importing the necessary dependencies
import 'package:equatable/equatable.dart';
import '../../../recipes/data/model/recipe_model.dart';

// Feed Events
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FetchFeedsEvent extends FeedEvent {
  final String? category; // Optional category for filtering
  final String? sortBy;

  const FetchFeedsEvent({this.category, this.sortBy});

  @override
  List<Object?> get props => [category, sortBy];
}

class RefreshFeed extends FeedEvent {
  final String? category; // Optional category for filtering
  final String? sortBy;

  const RefreshFeed({this.category, this.sortBy});

  @override
  List<Object?> get props => [category, sortBy];
}

class UpdateFeedEvent extends FeedEvent {
  final Recipe recipe;

  const UpdateFeedEvent({
    required this.recipe,
  });

  @override
  List<Object?> get props => [recipe];
}

class FetchRecipeByIdEvent extends FeedEvent {
  final String recipeId;

  const FetchRecipeByIdEvent({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

class AddRecipeEvent extends FeedEvent {
  final Recipe recipe;

  const AddRecipeEvent({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

class FetchTrendingFeedsEvent extends FeedEvent {
  final int? limit;
  const FetchTrendingFeedsEvent({this.limit});
}

class SortFeedsEvent extends FeedEvent {
  final String
      sortBy; // The sort parameter, e.g., 'createdAt', 'popularity', etc.

  const SortFeedsEvent({required this.sortBy});

  @override
  List<Object?> get props => [sortBy];
}
