import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/bloc/follow/follow_status_cubit.dart';
import '../../../../../core/common/widgets/follow_button_widget.dart';
import '../../../../../injection/service_locator.dart';
import '../../../../user_profiles/data/model/user_model.dart';

class FollowRecipeCreatorSection extends StatelessWidget {
  final UserModel userModel;

  const FollowRecipeCreatorSection({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;
    // context.read<FollowingBloc>().add(FetchFollowStatus(creatorId: userModel.uid));
    context.read<FollowStatusCubit>().fetchFollowStatus(userModel.uid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Creator Profile Section
        Row(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundImage: userModel.photoURL != null && userModel.photoURL!.isNotEmpty
                  ? NetworkImage(userModel.photoURL!)
                  : null,
              child: userModel.photoURL == null || userModel.photoURL!.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              userModel.displayName!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (userModel.uid != user!.uid)
          // Follow/Unfollow Button
          FollowButtonWidget(userModel: userModel),
      ],
    );
  }
}
