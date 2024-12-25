import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/common/bloc/follow/follow_status_cubit.dart';
import '../features/favorites/domain/favorite_bloc.dart';
import '../features/feed/domain/feeds/featured_feed_bloc.dart';
import '../features/feed/domain/feeds/feed_bloc.dart';
import '../features/feed/domain/feeds/feed_event.dart';
import '../core/common/bloc/like/like_bloc.dart';
import '../features/feed/domain/search/search_bloc.dart';
import '../features/recipes/domain/list_recipe/list_recipe_bloc.dart';
import '../features/recipes/domain/recipe/recipe_bloc.dart';
import '../features/user_profiles/domain/following/following_bloc.dart';
import '../features/user_profiles/domain/profile/profile_bloc.dart';
import '../features/user_profiles/domain/user_list/user_list_bloc.dart';
import '../features/user_profiles/domain/user_recipes/user_recipes_bloc.dart';

import 'features/auth/domain/auth_bloc.dart';
import 'features/recipes/domain/comment/comment_bloc.dart';
import 'features/user_profiles/domain/follower/follower_bloc.dart';
import 'injection/service_locator.dart';
import 'router/app_router.dart';
import 'firebase_options.dart';

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  if (dotenv.isInitialized) {
    print("Env file loaded successfully");
  } else {
    print("Env file failed to load");
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'demo');

  // Setup dependency injection
  setupDependencies();
}

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc using GetIt
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(AuthStarted()),
        ),
        // Provide FeedBloc using GetIt
        BlocProvider<FeedBloc>(
          create: (_) => getIt<FeedBloc>()..add(const FetchFeedsEvent()),
        ),
        BlocProvider<FeaturedFeedBloc>(
          create: (_) =>
              getIt<FeaturedFeedBloc>()..add(FetchFeaturedFeedsEvent()),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => getIt<SearchBloc>(),
        ),
        BlocProvider<FavoriteBloc>(
          create: (_) => getIt<FavoriteBloc>()..add(FetchFavorites()),
        ),
        BlocProvider<ListRecipeBloc>(
          create: (_) => getIt<ListRecipeBloc>(),
        ),
        BlocProvider<RecipeBloc>(
          create: (_) => getIt<RecipeBloc>(),
        ),
        BlocProvider<LikeBloc>(
          create: (_) => getIt<LikeBloc>(),
        ),
        BlocProvider<CommentBloc>(
          create: (_) => getIt<CommentBloc>(),
        ),
        BlocProvider<FollowingBloc>(
          create: (_) => getIt<FollowingBloc>(),
        ),
        BlocProvider<FollowerBloc>(
          create: (_) => getIt<FollowerBloc>(),
        ),
        BlocProvider<FollowStatusCubit>(
          create: (_) => getIt<FollowStatusCubit>(),
        ),
        BlocProvider<UserListBloc>(
          create: (_) => getIt<UserListBloc>(),
        ),
        BlocProvider<UserRecipeBloc>(
          create: (_) => getIt<UserRecipeBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>()..add(FetchProfile()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().config(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
