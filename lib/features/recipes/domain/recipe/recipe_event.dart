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
  final List<XFile> imagesToAdd;

  const AddRecipeEvent({required this.recipe, required this.imagesToAdd});

  @override
  List<Object?> get props => [recipe, imagesToAdd];
}

class UpdateRecipeEvent extends RecipeEvent {
  final Recipe oldRecipe;
  final Recipe newRecipe;
  final List<XFile> imagesToAdd;
  // final List<String> imagesToDelete;

  const UpdateRecipeEvent({
    required this.oldRecipe,
    required this.newRecipe,
    required this.imagesToAdd,
  });

  @override
  List<Object?> get props => [oldRecipe, newRecipe, imagesToAdd];
  // List<Object?> get props => [recipe, imagesToAdd, imagesToDelete];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String recipeId;

  const DeleteRecipeEvent(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
