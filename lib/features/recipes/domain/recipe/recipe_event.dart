part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecipeByIdEvent extends RecipeEvent {
  final String recipeId;

  const FetchRecipeByIdEvent({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

class AddRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const AddRecipeEvent({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

class UpdateRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipeEvent({
    required this.recipe,
  });

  @override
  List<Object?> get props => [recipe];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String recipeId;

  const DeleteRecipeEvent(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
