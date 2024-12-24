import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features/user_profiles/data/repository/follow_repository.dart';

part 'follow_status_state.dart';

class FollowStatusCubit extends Cubit<FollowStatusState> {
  final FollowRepository followRepository;

  FollowStatusCubit(this.followRepository) : super(FollowStatusInitial());

  // Follow a user
  Future<void> followUser(String userId) async {
    try {
      emit(FollowStatusLoading());
      await followRepository.followUser(userId);
      emit(FollowStatusFollowingSuccess());
      await fetchFollowStatus(
          userId); // Update the follow status after following
    } catch (e) {
      emit(FollowStatusError(message: e.toString()));
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(String userId) async {
    try {
      emit(FollowStatusLoading());
      await followRepository.unfollowUser(userId);
      emit(FollowStatusFollowingSuccess());
      await fetchFollowStatus(
          userId); // Update the follow status after unfollowing
    } catch (e) {
      emit(FollowStatusError(message: e.toString()));
    }
  }

  // Fetch follow status
  Future<void> fetchFollowStatus(String userId) async {
    try {
      emit(FollowStatusLoading());
      final isFollowing = await followRepository.isFollowing(userId);
      emit(FollowStatusLoaded(isFollowing: isFollowing));
    } catch (e) {
      emit(FollowStatusError(message: e.toString()));
    }
  }
}
