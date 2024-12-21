// lib/features/following/presentation/bloc/following_state.dart
part of 'following_bloc.dart';

abstract class FollowingState extends Equatable {
  const FollowingState();

  @override
  List<Object> get props => [];
}

class FollowingInitial extends FollowingState {}

class FollowingInProgress extends FollowingState {}

class FollowingSuccess extends FollowingState {}

class FollowingError extends FollowingState {
  final String message;

  const FollowingError({required this.message});

  @override
  List<Object> get props => [message];
}

class FetchFollowingsLoading extends FollowingState {}

class FetchFollowingsLoaded extends FollowingState {
  final List<UserModel> followings;

  const FetchFollowingsLoaded({required this.followings});

  @override
  List<Object> get props => [followings];
}

class CountFollowingsLoading extends FollowingState {}

class CountFollowingsLoaded extends FollowingState {
  final int count;

  const CountFollowingsLoaded({required this.count});

  @override
  List<Object> get props => [count];
}
