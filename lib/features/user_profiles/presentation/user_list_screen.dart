import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/user_list/user_list_bloc.dart';
import 'widgets/user_list.dart';

@RoutePage()
class UserListScreen extends StatelessWidget {
  final String userId;
  final String title;

  const UserListScreen({super.key, required this.userId, required this.title});

  @override
  Widget build(BuildContext context) {
    if (title.contains("Followers")) {
      context.read<UserListBloc>().add(FetchUserListFollowers(userId: userId));
    } else if (title.contains("Followings")) {
      context.read<UserListBloc>().add(FetchUserListFollowings(userId: userId));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<UserListBloc, UserListState>(
            builder: (context, state) {
              if (state is FetchUserListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FetchUserListLoaded) {
                return UserList(userModels: state.users);
              } else if (state is UserListError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
