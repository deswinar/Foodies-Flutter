import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/recipe_model.dart';
import '../../data/repository/recipe_repository.dart';

part 'list_recipe_event.dart';
part 'list_recipe_state.dart';

class ListRecipeBloc extends Bloc<ListRecipeEvent, ListRecipeState> {
  final RecipeRepository recipeRepository;

  ListRecipeBloc(this.recipeRepository) : super(ListRecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      emit(ListRecipeLoading());
      try {
        final recipes = await recipeRepository.getAllRecipes();
        emit(ListRecipeLoaded(recipes: recipes));
      } catch (e) {
        emit(ListRecipeError(errorMessage: e.toString()));
      }
    });
  }
}
