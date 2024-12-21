part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class FetchLikeStatus extends LikeEvent {
  final String recipeId;

  const FetchLikeStatus(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class ToggleLike extends LikeEvent {
  final String recipeId;

  const ToggleLike(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
