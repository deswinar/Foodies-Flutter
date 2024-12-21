import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';

import '../../data/repository/follow_repository.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final FollowRepository followRepository;
  
  UserListBloc(this.followRepository) : super(UserListInitial()) {
    on<FetchUserListFollowings>((event, emit) async {
      try {
        emit(FetchUserListLoading());
        final followings = await followRepository.fetchFollowings(event.userId);
        emit(FetchUserListLoaded(users: followings));
      } catch (e) {
        emit(UserListError(message: e.toString()));
      }
    });

    on<FetchUserListFollowers>((event, emit) async {
      try {
        emit(FetchUserListLoading());
        final followings = await followRepository.fetchFollowers(event.userId);
        emit(FetchUserListLoaded(users: followings));
      } catch (e) {
        emit(UserListError(message: e.toString()));
      }
    });
  }
}
