import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../injection/service_locator.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {

  AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = getIt<FirebaseAuth>().currentUser;

    if (user != null) {
      resolver.next(true);
    } else {
      router.push(LoginRoute());
    }
  }
}