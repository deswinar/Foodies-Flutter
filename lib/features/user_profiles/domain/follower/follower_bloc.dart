import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/features/user_profiles/data/model/follower_model.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';

import '../../data/repository/follow_repository.dart';

part 'follower_event.dart';
part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final FollowRepository followRepository;

  FollowerBloc(this.followRepository) : super(FollowerInitial()) {
    on<FetchFollower>((event, emit) async {
      try {
        emit(FetchFollowersLoading());
        final followers = await followRepository.fetchFollowers(event.userId);
        emit(FetchFollowersLoaded(followers: followers));
      } catch (e) {
        emit(FollowerError(message: e.toString()));
      }
    });

    on<CountFollowers>((event, emit) async {
      try {
        emit(CountFollowersLoading());
        final count = await followRepository.countFollowers(event.userId);
        emit(CountFollowersLoaded(count: count));
      } catch (e) {
        emit(FollowerError(message: e.toString()));
      }
    });
  }
}
