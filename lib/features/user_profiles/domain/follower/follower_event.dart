part of 'follower_bloc.dart';

abstract class FollowerEvent extends Equatable {
  const FollowerEvent();

  @override
  List<Object> get props => [];
}

final class FetchFollower extends FollowerEvent {
  final String userId;

  const FetchFollower({required this.userId});
  
  @override
  List<Object> get props => [userId];
}

final class CountFollowers extends FollowerEvent {
  final String userId;

  const CountFollowers({required this.userId});

  @override
  List<Object> get props => [userId];
}


