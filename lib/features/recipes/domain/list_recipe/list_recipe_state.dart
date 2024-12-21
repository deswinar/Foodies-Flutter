part of 'list_recipe_bloc.dart';

abstract class ListRecipeState extends Equatable {
  const ListRecipeState();

  @override
  List<Object?> get props => [];
}

class ListRecipeInitial extends ListRecipeState {}

class ListRecipeLoading extends ListRecipeState {}

class ListRecipeLoaded extends ListRecipeState {
  final List<Recipe> recipes;

  const ListRecipeLoaded({required this.recipes});

  @override
  List<Object?> get props => [recipes];
}

class ListRecipeError extends ListRecipeState {
  final String errorMessage;

  const ListRecipeError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
