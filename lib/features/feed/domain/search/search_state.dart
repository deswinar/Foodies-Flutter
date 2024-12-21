part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadingMoreState extends SearchState {
  final List<Recipe> searchResults;

  const SearchLoadingMoreState(this.searchResults);

  @override
  List<Object?> get props => [searchResults];
}

class SearchLoadedState extends SearchState {
  final List<Recipe> searchResults;
  final bool hasMore;

  const SearchLoadedState({required this.searchResults, required this.hasMore});

  @override
  List<Object?> get props => [searchResults, hasMore];
}

class SearchErrorState extends SearchState {
  final String errorMessage;

  const SearchErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
