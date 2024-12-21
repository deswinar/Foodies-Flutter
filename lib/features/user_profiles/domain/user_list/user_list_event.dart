part of 'user_list_bloc.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object> get props => [];
}

class FetchUserListFollowings extends UserListEvent {
  final String userId;

  const FetchUserListFollowings({required this.userId});

  @override
  List<Object> get props => [userId];
}

class FetchUserListFollowers extends UserListEvent {
  final String userId;

  const FetchUserListFollowers({required this.userId});

  @override
  List<Object> get props => [userId];
}
