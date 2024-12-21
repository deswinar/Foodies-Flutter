part of 'user_list_bloc.dart';

abstract class UserListState extends Equatable {
  const UserListState();
  
  @override
  List<Object> get props => [];
}

final class UserListInitial extends UserListState {}

final class FetchUserListLoading extends UserListState {}

final class FetchUserListLoaded extends UserListState {
  final List<UserModel> users;

  const FetchUserListLoaded({required this.users});
  
  @override
  List<Object> get props => [users];
}

final class UserListError extends UserListState {
  final String message;

  const UserListError({required this.message});

  @override
  List<Object> get props => [message];
}

