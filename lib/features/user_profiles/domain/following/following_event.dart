// lib/features/following/presentation/bloc/following_event.dart
part of 'following_bloc.dart';

abstract class FollowingEvent extends Equatable {
  const FollowingEvent();

  @override
  List<Object> get props => [];
}

class FollowUser extends FollowingEvent {
  final String userId;

  const FollowUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UnfollowUser extends FollowingEvent {
  final String userId;

  const UnfollowUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class FetchFollowStatus extends FollowingEvent {
  final String creatorId;

  const FetchFollowStatus({required this.creatorId});

  @override
  List<Object> get props => [creatorId];
}

class FetchFollowings extends FollowingEvent {
  final String userId;

  const FetchFollowings({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CountFollowings extends FollowingEvent {
  final String userId;

  const CountFollowings({required this.userId});

  @override
  List<Object> get props => [userId];
}
