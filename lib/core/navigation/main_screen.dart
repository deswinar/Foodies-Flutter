import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/auth_bloc.dart';
import 'package:myapp/features/auth/domain/auth_state.dart';
import 'package:myapp/features/favorites/presentation/favorite_screen.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';
import 'package:myapp/features/user_profiles/presentation/profile_screen.dart';
import 'package:myapp/router/app_router.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../injection/service_locator.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.replaceRoute(LoginRoute());
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
