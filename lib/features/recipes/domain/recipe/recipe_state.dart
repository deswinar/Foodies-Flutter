part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitialState extends RecipeState {}

class RecipeLoadingState extends RecipeState {}

class RecipeLoadedState extends RecipeState {
  final Recipe recipe;

  const RecipeLoadedState({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

class RecipeErrorState extends RecipeState {
  final String errorMessage;

  const RecipeErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

// New States for Adding a Recipe
class RecipeAddingState extends RecipeState {}

class RecipeAddedState extends RecipeState {
  final Recipe recipe;

  const RecipeAddedState(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeUpdatingState extends RecipeState {}

class RecipeUpdatedState extends RecipeState {
  final Recipe recipe;

  const RecipeUpdatedState({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

class RecipeDeletingState extends RecipeState {}

class RecipeDeletedState extends RecipeState {
  final String recipeId;

  const RecipeDeletedState({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}
