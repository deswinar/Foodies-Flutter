import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../features/recipes/data/model/recipe_model.dart';
import '../data/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc({required this.favoriteRepository}) : super(FavoriteInitial()) {
    on<FetchFavorites>(_onFetchFavorites);
  }

  Future<void> _onFetchFavorites(
      FetchFavorites event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());

      // Fetch user's liked recipes ordered by `likedAt`
      final favoriteRecipes =
          await favoriteRepository.fetchUserFavorites();

      emit(FavoriteLoaded(favoriteRecipes));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }
}
