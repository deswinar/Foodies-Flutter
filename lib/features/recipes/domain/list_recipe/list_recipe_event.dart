part of 'list_recipe_bloc.dart';

abstract class ListRecipeEvent extends Equatable {
  const ListRecipeEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecipesEvent extends ListRecipeEvent {}