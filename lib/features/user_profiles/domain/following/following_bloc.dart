import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/follow_repository.dart';

part 'following_event.dart';
part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final FollowRepository followRepository;

  FollowingBloc(this.followRepository) : super(FollowingInitial()) {
    // Handle FollowUser event
    on<FollowUser>((event, emit) async {
      try {
        emit(FollowingInProgress());
        // Perform the follow operation using the repository
        await followRepository.followUser(event.userId);
        emit(FollowingSuccess());
        add(FetchFollowStatus(creatorId: event.userId));
      } catch (e) {
        emit(FollowingError(message: e.toString()));
      }
    });

    // Handle UnfollowUser event
    on<UnfollowUser>((event, emit) async {
      try {
        emit(FollowingInProgress());
        // Perform the unfollow operation using the repository
        await followRepository.unfollowUser(event.userId);
        emit(FollowingSuccess());
        add(FetchFollowStatus(creatorId: event.userId));
      } catch (e) {
        emit(FollowingError(message: e.toString()));
      }
    });

    on<FetchFollowings>((event, emit) async {
      try {
        emit(FetchFollowingsLoading());
        final followings = await followRepository.fetchFollowings(event.userId);
        emit(FetchFollowingsLoaded(followings: followings));
      } catch (e) {
        emit(FollowingError(message: e.toString()));
      }
    });

    on<CountFollowings>((event, emit) async {
      try {
        emit(CountFollowingsLoading());
        final count = await followRepository.countFollowings(event.userId);
        emit(CountFollowingsLoaded(count: count));
      } catch (e) {
        emit(FollowingError(message: e.toString()));
      }
    });
  }
}
