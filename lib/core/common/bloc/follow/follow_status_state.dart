part of 'follow_status_cubit.dart';

abstract class FollowStatusState extends Equatable {
  const FollowStatusState();

  @override
  List<Object> get props => [];
}

class FollowStatusInitial extends FollowStatusState {}

class FollowStatusLoading extends FollowStatusState {}

class FollowStatusLoaded extends FollowStatusState {
  final bool isFollowing;

  const FollowStatusLoaded({required this.isFollowing});
}

class FollowStatusFollowingSuccess extends FollowStatusState {}

class FollowStatusError extends FollowStatusState {
  final String message;

  const FollowStatusError({required this.message});
}