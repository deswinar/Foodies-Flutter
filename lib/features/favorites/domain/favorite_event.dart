part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFavorites extends FavoriteEvent {
  FetchFavorites();

  @override
  List<Object?> get props => [];
}
