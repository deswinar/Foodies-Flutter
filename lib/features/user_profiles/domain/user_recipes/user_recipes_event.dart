part of 'user_recipes_bloc.dart';

abstract class UserRecipeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserRecipes extends UserRecipeEvent {
  final UserModel userModel;
  FetchUserRecipes({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

class UpdateUserRecipeEvent extends UserRecipeEvent {
  final Recipe recipe;

  UpdateUserRecipeEvent({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}
