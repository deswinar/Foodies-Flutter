import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/common/widgets/follow_button_widget.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';
import 'package:myapp/features/user_profiles/presentation/profile_screen.dart';
import 'package:myapp/router/app_router.dart';

import '../../../../core/common/bloc/follow/follow_status_cubit.dart';

class UserList extends StatelessWidget {
  final List<UserModel> userModels;
  const UserList({
    super.key,
    required this.userModels,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: userModels.length,
        itemBuilder: (context, index) {
          final user = userModels[index];
          print(user.displayName);
          return ListTile(
            onTap: () {
              context.pushRoute(UserRecipesRoute(userModel: user));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
            title: Text(user.displayName ?? ''),
            trailing: FollowButtonWidget(userModel: user),
            // Add other user details as needed
          );
        },
      ),
    );
  }
}
