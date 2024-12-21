import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/core/common/bloc/follow/follow_status_cubit.dart';
import 'package:myapp/features/favorites/data/favorite_repository.dart';
import 'package:myapp/features/favorites/domain/favorite_bloc.dart';
import 'package:myapp/features/feed/data/feed_repository.dart';
import 'package:myapp/features/feed/domain/feeds/featured_feed_bloc.dart';
import 'package:myapp/features/feed/domain/feeds/feed_bloc.dart';
import 'package:myapp/features/feed/domain/search/search_bloc.dart';
import 'package:myapp/features/recipes/data/repository/comment_repository.dart';
import 'package:myapp/core/common/bloc/like/like_repository.dart';
import 'package:myapp/features/recipes/domain/comment/comment_bloc.dart';
import 'package:myapp/core/common/bloc/like/like_bloc.dart';
import 'package:myapp/features/user_profiles/data/repository/follow_repository.dart';
import 'package:myapp/features/user_profiles/data/repository/profile_repository.dart';
import 'package:myapp/features/user_profiles/data/repository/user_recipes_repository.dart';
import 'package:myapp/features/user_profiles/domain/following/following_bloc.dart';
import 'package:myapp/features/user_profiles/domain/profile/profile_bloc.dart';
import 'package:myapp/features/user_profiles/domain/user_recipes/user_recipes_bloc.dart';
import '../core/services/cloudinary_service.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_bloc.dart';
import '../features/recipes/data/repository/recipe_repository.dart';
import '../features/recipes/domain/list_recipe/list_recipe_bloc.dart';
import '../features/recipes/domain/recipe/recipe_bloc.dart';
import '../features/user_profiles/domain/follower/follower_bloc.dart';
import '../features/user_profiles/domain/user_list/user_list_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register FirebaseAuth as a lazy singleton
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Register CloudinaryService as a singleton
  getIt.registerLazySingleton(
      () => CloudinaryObject.fromCloudName(cloudName: 'djnfz4ehq'));
  getIt.registerLazySingleton(() => CloudinaryService());

  // Register Repositories (One instance, created only when first needed)
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<FirebaseAuth>()));

  // Register Blocs (New instance every time it is requested)
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  // Register FeedRepository
  getIt.registerLazySingleton<FeedRepository>(() => FeedRepository(
        getIt<FirebaseFirestore>(),
        getIt<AuthRepository>(),
      ));

  // Register FeedBloc, using FeedRepository
  getIt.registerFactory<FeedBloc>(() => FeedBloc(getIt<FeedRepository>()));
  getIt.registerFactory<FeaturedFeedBloc>(
      () => FeaturedFeedBloc(getIt<FeedRepository>()));
  getIt.registerFactory<SearchBloc>(() => SearchBloc(getIt<FeedRepository>()));

  getIt.registerLazySingleton<RecipeRepository>(
      () => RecipeRepository(firestore: getIt<FirebaseFirestore>()));
  getIt
      .registerFactory<RecipeBloc>(() => RecipeBloc(getIt<RecipeRepository>()));
  getIt.registerFactory<ListRecipeBloc>(
      () => ListRecipeBloc(getIt<RecipeRepository>()));

  getIt.registerLazySingleton<LikeRepository>(
      () => LikeRepository(firestore: getIt<FirebaseFirestore>()));
  getIt.registerFactory<LikeBloc>(
      () => LikeBloc(likeRepository: getIt<LikeRepository>()));

  getIt.registerLazySingleton<CommentRepository>(
      () => CommentRepository(firestore: getIt<FirebaseFirestore>()));
  getIt.registerFactory<CommentBloc>(
      () => CommentBloc(getIt<CommentRepository>()));

  getIt.registerLazySingleton<FollowRepository>(
      () => FollowRepository(firestore: getIt<FirebaseFirestore>()));
  getIt.registerFactory<FollowingBloc>(
      () => FollowingBloc(getIt<FollowRepository>()));
  getIt.registerFactory<FollowerBloc>(
      () => FollowerBloc(getIt<FollowRepository>()));
  getIt.registerFactory<FollowStatusCubit>(
      () => FollowStatusCubit(getIt<FollowRepository>()));

  getIt.registerFactory<UserListBloc>(
      () => UserListBloc(getIt<FollowRepository>()));

  getIt.registerLazySingleton<UserRecipeRepository>(
      () => UserRecipeRepository());
  getIt.registerFactory<UserRecipeBloc>(() =>
      UserRecipeBloc(userRecipeRepository: getIt<UserRecipeRepository>()));

  getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepository());
  getIt.registerFactory<FavoriteBloc>(
      () => FavoriteBloc(favoriteRepository: getIt<FavoriteRepository>()));

  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository());
  getIt.registerFactory<ProfileBloc>(() =>
      ProfileBloc(profileRepository: getIt<ProfileRepository>()));
}
