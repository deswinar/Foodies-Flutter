import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../router/app_router.dart';
import '../../auth/domain/auth_bloc.dart';
import '../../auth/domain/auth_event.dart';
import '../../auth/domain/auth_state.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLoginStatus(context);
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    // Simulate a short delay for Splash Screen display (optional)
    await Future.delayed(const Duration(seconds: 2));

    final authBloc = context.read<AuthBloc>();

    // Listen to auth state and navigate accordingly
    authBloc.stream.listen((state) {
      if (state is AuthAuthenticated) {
        context.replaceRoute(
            const MainRoute()); // Navigate to home if authenticated
      } else if (state is AuthUnauthenticated || state is AuthInitial) {
        context.replaceRoute(
            LoginRoute()); // Navigate to login if not authenticated
      }
    });

    authBloc.add(AuthStarted()); // Trigger auth check
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Your app logo
              height: 120,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
