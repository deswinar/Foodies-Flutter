part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchRecipesEvent extends SearchEvent {
  final String query;

  const SearchRecipesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class FetchMoreSearchResultsEvent extends SearchEvent {
  final String query;

  const FetchMoreSearchResultsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {}

