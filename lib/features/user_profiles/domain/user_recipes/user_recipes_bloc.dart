import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';
import '../../../recipes/data/model/recipe_model.dart';
import '../../data/repository/user_recipes_repository.dart';

part 'user_recipes_event.dart';
part 'user_recipes_state.dart';

class UserRecipeBloc extends Bloc<UserRecipeEvent, UserRecipeState> {
  final UserRecipeRepository userRecipeRepository;

  UserRecipeBloc({required this.userRecipeRepository})
      : super(UserRecipeInitial()) {
    on<FetchUserRecipes>(_onFetchUserRecipes);
    on<UpdateUserRecipeEvent>(_onUpdateUserRecipe);
  }

  Future<void> _onFetchUserRecipes(
      FetchUserRecipes event, Emitter<UserRecipeState> emit) async {
    try {
      emit(UserRecipeLoading());

      // Fetch user's liked recipes ordered by `likedAt`
      final userRecipes = await userRecipeRepository.fetchUserRecipes(userModel: event.userModel);

      emit(UserRecipeLoaded(userRecipes));
    } catch (e) {
      emit(UserRecipeError('Failed to load UserRecipes: $e'));
    }
  }

  Future<void> _onUpdateUserRecipe(
      UpdateUserRecipeEvent event, Emitter<UserRecipeState> emit) async {
    if (state is UserRecipeLoaded) {
      final currentState = state as UserRecipeLoaded;

      // Update the specific recipe in the list
      final updatedRecipes = currentState.userRecipes.map((r) {
        return r.id == event.recipe.id ? event.recipe : r;
      }).toList();

      emit(UserRecipeLoaded(updatedRecipes));
    }
  }
}
