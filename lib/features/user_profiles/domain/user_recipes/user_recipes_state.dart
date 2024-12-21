part of 'user_recipes_bloc.dart';

abstract class UserRecipeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserRecipeInitial extends UserRecipeState {}

class UserRecipeLoading extends UserRecipeState {}

class UserRecipeLoaded extends UserRecipeState {
  final List<Recipe> userRecipes;

  UserRecipeLoaded(this.userRecipes);

  @override
  List<Object?> get props => [userRecipes];
}

class UserRecipeError extends UserRecipeState {
  final String message;

  UserRecipeError(this.message);

  @override
  List<Object?> get props => [message];
}
