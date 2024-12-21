import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:myapp/features/recipes/presentation/edit_recipe_screen.dart';
import 'package:myapp/features/recipes/presentation/recipe_details_screen.dart';
import 'package:myapp/features/user_profiles/presentation/edit_profile_screen.dart';
import 'package:myapp/features/user_profiles/presentation/profile_screen.dart';
import 'package:myapp/features/user_profiles/presentation/user_list_screen.dart';
import 'package:myapp/features/user_profiles/presentation/user_recipes_screen.dart';
import '../features/recipes/presentation/add_recipe_screen.dart';
import '../core/navigation/main_screen.dart';
import '../features/feed/presentation/feed_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/recipes/data/model/recipe_model.dart';
import '../features/user_profiles/data/model/user_model.dart';

// The part directive must be after imports
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: MainRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: FeedRoute.page),
        AutoRoute(page: RecipeDetailsRoute.page),
        AutoRoute(page: AddRecipeRoute.page),
        AutoRoute(page: EditRecipeRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: UserRecipesRoute.page),
        AutoRoute(page: UserListRoute.page),
        AutoRoute(page: EditProfileRoute.page),
      ];
}
