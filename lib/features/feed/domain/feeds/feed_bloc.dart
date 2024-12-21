import 'package:bloc/bloc.dart';
import '../../data/feed_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _feedRepository;

  bool _hasMore = true; // To track if there are more recipes to fetch
  String? _lastFetchedId; // Track the last fetched recipe for pagination
  final int _limit = 10; // Number of recipes to fetch per request
  String? _selectedCategory; // Track the currently selected category
  String _sortBy = 'createdAt'; // Default sorting by creation date

  FeedBloc(this._feedRepository) : super(FeedsLoadingState()) {
    on<FetchFeedsEvent>(_onFetchFeeds);
    on<SortFeedsEvent>(_onSortFeeds);
    on<UpdateFeedEvent>(_onUpdateFeed);
    on<RefreshFeed>(_onRefreshFeed);
  }

  Future<void> _onFetchFeeds(
    FetchFeedsEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Reset pagination and data if the category or sort changes
      if (event.category != _selectedCategory || event.sortBy != _sortBy) {
        _selectedCategory = event.category;
        _sortBy = event.sortBy ?? _sortBy; // Use the sort passed in the event
        _lastFetchedId = null;
        _hasMore = true; // Reset the flag for more data
        emit(FeedsLoadingState());
      }

      if (!_hasMore) return;

      if (state is! FeedsLoadedState) {
        emit(FeedsLoadingState());
      }

      final currentRecipes =
          state is FeedsLoadedState ? (state as FeedsLoadedState).recipes : [];

      // Fetch new recipes with the selected category and sort order
      final newRecipes = await _feedRepository.fetchRecipes(
        limit: _limit,
        startAfter: _lastFetchedId,
        category: _selectedCategory,
        sortBy: _sortBy, // Pass the sorting option
      );

      if (newRecipes.isEmpty) {
        _hasMore = false;
      } else {
        _lastFetchedId = newRecipes.last.id; // Update the pagination marker
      }

      emit(FeedsLoadedState(
        recipes: [...currentRecipes, ...newRecipes],
        category: _selectedCategory,
        sortBy: _sortBy, // Keep track of the sorting option
      ));
    } catch (e) {
      emit(FeedsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshFeed(
    RefreshFeed event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Reset pagination markers for refresh
      _lastFetchedId = null;
      _hasMore = true;
      emit(FeedsLoadingState());

      // Fetch fresh recipes with current category and sort
      final newRecipes = await _feedRepository.fetchRecipes(
        limit: _limit,
        category: _selectedCategory,
        sortBy: _sortBy,
      );

      if (newRecipes.isEmpty) {
        _hasMore = false;
      } else {
        _lastFetchedId = newRecipes.last.id; // Update the pagination marker
      }

      emit(FeedsLoadedState(
        recipes: newRecipes,
        category: _selectedCategory,
        sortBy: _sortBy,
      ));
    } catch (e) {
      emit(FeedsErrorState(errorMessage: e.toString()));
    }
  }

  // Handle sorting when the sort option changes
  Future<void> _onSortFeeds(SortFeedsEvent event, Emitter<FeedState> emit) async {
    _sortBy = event.sortBy;
    add(FetchFeedsEvent(category: _selectedCategory, sortBy: _sortBy));
  }

  Future<void> _onUpdateFeed(
    UpdateFeedEvent event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Get the current list of recipes
      final currentState = state;
      if (currentState is FeedsLoadedState) {
        // Update the recipe in Firestore via the repository
        await _feedRepository.updateRecipe(event.recipe);

        final updatedRecipes = currentState.recipes.map((recipe) {
          // Replace the updated recipe in the list
          return recipe.id == event.recipe.id ? event.recipe : recipe;
        }).toList();

        // Emit the new state with updated recipes
        emit(FeedsLoadedState(recipes: updatedRecipes));
      }
    } catch (e) {
      // Emit error state if something goes wrong
      emit(FeedsErrorState(errorMessage: e.toString()));
    }
  }
}
