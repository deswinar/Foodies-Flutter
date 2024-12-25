import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/user_profiles/data/model/user_model.dart';
import '../bloc/follow/follow_status_cubit.dart';

class FollowButtonWidget extends StatelessWidget {
  const FollowButtonWidget({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowStatusCubit, FollowStatusState>(
      builder: (context, state) {
        if (state is FollowStatusInitial) {
          context.read<FollowStatusCubit>().fetchFollowStatus(userModel.uid);
        }
        if (state is FollowStatusLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if the user is following the creator
        bool isFollowing = false;
        if (state is FollowStatusLoaded) {
          isFollowing = state.isFollowing;
        }
        print(state);

        return ElevatedButton(
          onPressed: () {
            if (isFollowing) {
              context.read<FollowStatusCubit>().unfollowUser(userModel.uid);
            } else {
              context.read<FollowStatusCubit>().followUser(userModel.uid);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.red : Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(isFollowing ? 'Unfollow' : 'Follow'),
        );
      },
    );
  }
}
