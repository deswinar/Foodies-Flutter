// Importing the necessary dependencies
import 'package:equatable/equatable.dart';
import '../../../recipes/data/model/recipe_model.dart';

// Feed States
abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedsLoadingState extends FeedState {}

class FeedsLoadedState extends FeedState {
  final List<Recipe> recipes;
  final String? category;
  final String? sortBy;

  const FeedsLoadedState({required this.recipes, this.category, this.sortBy});

  @override
  List<Object?> get props => [recipes, sortBy];
}

class FeedsErrorState extends FeedState {
  final String errorMessage;

  const FeedsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class FeedLoadingState extends FeedState {}

class FeedLoadedState extends FeedState {
  final Recipe recipe;

  const FeedLoadedState({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

class FeedAddedState extends FeedState {
  final Recipe recipe;

  const FeedAddedState({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}
