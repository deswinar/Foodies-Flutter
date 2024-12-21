import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../recipes/data/model/recipe_model.dart';
import '../../data/feed_repository.dart';

// Define Events
abstract class FeaturedFeedEvent {}

class FetchFeaturedFeedsEvent extends FeaturedFeedEvent {}

// Define States
abstract class FeaturedFeedState {}

class FeaturedFeedInitial extends FeaturedFeedState {}

class FeaturedFeedLoading extends FeaturedFeedState {}

class FeaturedFeedLoaded extends FeaturedFeedState {
  final List<Recipe> featuredRecipes;

  FeaturedFeedLoaded(this.featuredRecipes);
}

class FeaturedFeedError extends FeaturedFeedState {
  final String errorMessage;

  FeaturedFeedError(this.errorMessage);
}

// Bloc Implementation
class FeaturedFeedBloc extends Bloc<FeaturedFeedEvent, FeaturedFeedState> {
  final FeedRepository _feedRepository;

  FeaturedFeedBloc(this._feedRepository) : super(FeaturedFeedInitial()) {
    on<FetchFeaturedFeedsEvent>(_onFetchFeaturedFeeds);
  }

  Future<void> _onFetchFeaturedFeeds(
    FetchFeaturedFeedsEvent event,
    Emitter<FeaturedFeedState> emit,
  ) async {
    emit(FeaturedFeedLoading());
    try {
      final featuredRecipes = await _feedRepository.fetchTrendingRecipes();
      emit(FeaturedFeedLoaded(featuredRecipes));
    } catch (e) {
      emit(FeaturedFeedError(e.toString()));
    }
  }
}
