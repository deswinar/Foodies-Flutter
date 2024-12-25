import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/widgets/follow_button_widget.dart';
import '../../../../router/app_router.dart';
import '../../data/model/user_model.dart';

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
