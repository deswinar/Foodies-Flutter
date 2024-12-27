import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/domain/auth_bloc.dart';
import '../../features/favorites/presentation/favorite_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/user_profiles/domain/profile/profile_bloc.dart';
import '../../features/user_profiles/presentation/profile_screen.dart';
import '../../injection/service_locator.dart';
import '../../router/app_router.dart';
import 'bottom_nav_bar.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthUnauthenticated) {
        // context.read<ProfileBloc>().add(ProfileLogout());
        context.replaceRoute(LoginRoute());
      } else if (state is AuthAuthenticated) {
        context.read<ProfileBloc>().add(FetchProfile());
      }
    }, builder: (context, state) {
      // if (state is AuthAuthenticated) {
      // throw (state is AuthAuthenticated ? state.user.email!:"");
      return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Add Recipe screen
            context.router.push(const AddRecipeRoute());
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .miniEndFloat, // Move FAB to the bottom-right
      );
      // context.read<ProfileBloc>().add(FetchProfile());
      // } else {
      //   return const Center(child: CircularProgressIndicator());
      // }
    });
  }
}
