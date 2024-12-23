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
  final List<dynamic> imagesToAdd;
  final List<String> imagesToDelete;

  const UpdateRecipeEvent({
    required this.recipe,
    required this.imagesToAdd,
    required this.imagesToDelete,
  });

  @override
  List<Object?> get props => [recipe, imagesToAdd, imagesToDelete];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String recipeId;

  const DeleteRecipeEvent(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
