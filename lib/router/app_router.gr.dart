// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddRecipeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddRecipeScreen(),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditProfileScreen(
          user: args.user,
          key: args.key,
        ),
      );
    },
    EditRecipeRoute.name: (routeData) {
      final args = routeData.argsAs<EditRecipeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditRecipeScreen(
          key: args.key,
          recipe: args.recipe,
        ),
      );
    },
    FeedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FeedScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(key: args.key),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    RecipeDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<RecipeDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RecipeDetailsScreen(
          key: args.key,
          recipe: args.recipe,
          userModel: args.userModel,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterRouteArgs>(
          orElse: () => const RegisterRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterScreen(key: args.key),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    UserListRoute.name: (routeData) {
      final args = routeData.argsAs<UserListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserListScreen(
          key: args.key,
          userId: args.userId,
          title: args.title,
        ),
      );
    },
    UserRecipesRoute.name: (routeData) {
      final args = routeData.argsAs<UserRecipesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserRecipesScreen(
          key: args.key,
          userModel: args.userModel,
        ),
      );
    },
  };
}

/// generated route for
/// [AddRecipeScreen]
class AddRecipeRoute extends PageRouteInfo<void> {
  const AddRecipeRoute({List<PageRouteInfo>? children})
      : super(
          AddRecipeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddRecipeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditProfileScreen]
class EditProfileRoute extends PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    required UserModel user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          EditProfileRoute.name,
          args: EditProfileRouteArgs(
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static const PageInfo<EditProfileRouteArgs> page =
      PageInfo<EditProfileRouteArgs>(name);
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({
    required this.user,
    this.key,
  });

  final UserModel user;

  final Key? key;

  @override
  String toString() {
    return 'EditProfileRouteArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [EditRecipeScreen]
class EditRecipeRoute extends PageRouteInfo<EditRecipeRouteArgs> {
  EditRecipeRoute({
    Key? key,
    required Recipe recipe,
    List<PageRouteInfo>? children,
  }) : super(
          EditRecipeRoute.name,
          args: EditRecipeRouteArgs(
            key: key,
            recipe: recipe,
          ),
          initialChildren: children,
        );

  static const String name = 'EditRecipeRoute';

  static const PageInfo<EditRecipeRouteArgs> page =
      PageInfo<EditRecipeRouteArgs>(name);
}

class EditRecipeRouteArgs {
  const EditRecipeRouteArgs({
    this.key,
    required this.recipe,
  });

  final Key? key;

  final Recipe recipe;

  @override
  String toString() {
    return 'EditRecipeRouteArgs{key: $key, recipe: $recipe}';
  }
}

/// generated route for
/// [FeedScreen]
class FeedRoute extends PageRouteInfo<void> {
  const FeedRoute({List<PageRouteInfo>? children})
      : super(
          FeedRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RecipeDetailsScreen]
class RecipeDetailsRoute extends PageRouteInfo<RecipeDetailsRouteArgs> {
  RecipeDetailsRoute({
    Key? key,
    required Recipe recipe,
    required UserModel userModel,
    List<PageRouteInfo>? children,
  }) : super(
          RecipeDetailsRoute.name,
          args: RecipeDetailsRouteArgs(
            key: key,
            recipe: recipe,
            userModel: userModel,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeDetailsRoute';

  static const PageInfo<RecipeDetailsRouteArgs> page =
      PageInfo<RecipeDetailsRouteArgs>(name);
}

class RecipeDetailsRouteArgs {
  const RecipeDetailsRouteArgs({
    this.key,
    required this.recipe,
    required this.userModel,
  });

  final Key? key;

  final Recipe recipe;

  final UserModel userModel;

  @override
  String toString() {
    return 'RecipeDetailsRouteArgs{key: $key, recipe: $recipe, userModel: $userModel}';
  }
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<RegisterRouteArgs> page =
      PageInfo<RegisterRouteArgs>(name);
}

class RegisterRouteArgs {
  const RegisterRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserListScreen]
class UserListRoute extends PageRouteInfo<UserListRouteArgs> {
  UserListRoute({
    Key? key,
    required String userId,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
          UserListRoute.name,
          args: UserListRouteArgs(
            key: key,
            userId: userId,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'UserListRoute';

  static const PageInfo<UserListRouteArgs> page =
      PageInfo<UserListRouteArgs>(name);
}

class UserListRouteArgs {
  const UserListRouteArgs({
    this.key,
    required this.userId,
    required this.title,
  });

  final Key? key;

  final String userId;

  final String title;

  @override
  String toString() {
    return 'UserListRouteArgs{key: $key, userId: $userId, title: $title}';
  }
}

/// generated route for
/// [UserRecipesScreen]
class UserRecipesRoute extends PageRouteInfo<UserRecipesRouteArgs> {
  UserRecipesRoute({
    Key? key,
    required UserModel userModel,
    List<PageRouteInfo>? children,
  }) : super(
          UserRecipesRoute.name,
          args: UserRecipesRouteArgs(
            key: key,
            userModel: userModel,
          ),
          initialChildren: children,
        );

  static const String name = 'UserRecipesRoute';

  static const PageInfo<UserRecipesRouteArgs> page =
      PageInfo<UserRecipesRouteArgs>(name);
}

class UserRecipesRouteArgs {
  const UserRecipesRouteArgs({
    this.key,
    required this.userModel,
  });

  final Key? key;

  final UserModel userModel;

  @override
  String toString() {
    return 'UserRecipesRouteArgs{key: $key, userModel: $userModel}';
  }
}
