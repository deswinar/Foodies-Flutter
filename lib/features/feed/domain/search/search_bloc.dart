import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../recipes/data/model/recipe_model.dart';
import '../../data/feed_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FeedRepository _feedRepository;

  SearchBloc(this._feedRepository) : super(SearchInitialState()) {
    on<SearchRecipesEvent>(_onSearchRecipes);
    on<FetchMoreSearchResultsEvent>(_onFetchMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchRecipes(
    SearchRecipesEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoadingState());

    try {
      final results = await _feedRepository.searchFeeds(
        searchTerm: event.query,
        limit: 10,
        isInitialLoad: true,
      );

      emit(SearchLoadedState(
        searchResults: results,
        hasMore: _feedRepository.hasMore(),
      ));
    } catch (e) {
      emit(SearchErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchMoreSearchResults(
    FetchMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoadedState) return;

    final currentState = state as SearchLoadedState;

    if (!currentState.hasMore) return;

    emit(SearchLoadingMoreState(currentState.searchResults));

    try {
      final results = await _feedRepository.searchFeeds(
        searchTerm: event.query,
        limit: 10,
      );

      emit(SearchLoadedState(
        searchResults: currentState.searchResults + results,
        hasMore: _feedRepository.hasMore(),
      ));
    } catch (e) {
      emit(SearchErrorState(errorMessage: e.toString()));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitialState());
  }
}
