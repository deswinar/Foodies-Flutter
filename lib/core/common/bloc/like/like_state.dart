part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitial extends LikeState {}

class LikeLoading extends LikeState {}

class LikeSuccess extends LikeState {
  final bool isLiked;
  final int likeCount;

  const LikeSuccess({required this.isLiked, required this.likeCount});

  @override
  List<Object> get props => [isLiked, likeCount];
}

class LikeError extends LikeState {
  final String message;

  const LikeError(this.message);

  @override
  List<Object> get props => [message];
}
