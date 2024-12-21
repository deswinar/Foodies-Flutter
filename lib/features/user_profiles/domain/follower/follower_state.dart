part of 'follower_bloc.dart';

sealed class FollowerState extends Equatable {
  const FollowerState();

  @override
  List<Object> get props => [];
}

final class FollowerInitial extends FollowerState {}

// Suggested code may be subject to a license. Learn more: ~LicenseLog:1489920799.
final class FetchFollowersLoading extends FollowerState {}

final class FetchFollowersLoaded extends FollowerState {
  final List<UserModel> followers;

  const FetchFollowersLoaded({required this.followers});

  @override
  List<Object> get props => [followers];
}

final class FollowerError extends FollowerState {
  final String message;

  const FollowerError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CountFollowersLoading extends FollowerState {}

final class CountFollowersLoaded extends FollowerState {
  final int count;

  const CountFollowersLoaded({required this.count});

  @override
  List<Object> get props => [count];
}

