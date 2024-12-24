import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/recipe_model.dart';
import '../../data/repository/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc(this.recipeRepository) : super(RecipeInitialState()) {
    on<FetchRecipeByIdEvent>((event, emit) async {
      emit(RecipeLoadingState());
      try {
        final recipe = await recipeRepository.getRecipeById(event.recipeId);
        if (recipe != null) {
          emit(RecipeLoadedState(recipe: recipe));
        } else {
          emit(const RecipeErrorState(errorMessage: 'Recipe not found.'));
        }
      } catch (e) {
        emit(RecipeErrorState(errorMessage: e.toString()));
      }
    });

    on<AddRecipeEvent>((event, emit) async {
      emit(RecipeAddingState());
      try {
        final recipe = await recipeRepository.addRecipe(event.recipe);
        emit(RecipeAddedState(recipe));
      } catch (e) {
        emit(RecipeErrorState(errorMessage: e.toString()));
      }
    });

    on<UpdateRecipeEvent>((event, emit) async {
      emit(RecipeUpdatingState());
      try {
        // if (currentState is RecipeLoadedState) {
        // Update the recipe in Firestore via the repository
        await recipeRepository.updateRecipe(event.oldRecipe, event.newRecipe, event.imagesToAdd);

        final updatedRecipe = event.newRecipe;

        // Emit the new state with updated recipes
        emit(RecipeUpdatedState(recipe: updatedRecipe));
        // }
      } catch (e) {
        // Emit error state if something goes wrong
        emit(RecipeErrorState(errorMessage: e.toString()));
      }
    });

    on<DeleteRecipeEvent>((event, emit) async {
      emit(RecipeDeletingState());
      try {
        await recipeRepository.deleteRecipe(event.recipeId);
        emit(RecipeDeletedState(recipeId: event.recipeId));
      } catch (e) {
        emit(RecipeErrorState(errorMessage: e.toString()));
      }
    });
  }
}
