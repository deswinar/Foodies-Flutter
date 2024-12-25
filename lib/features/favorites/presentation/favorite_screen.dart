import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/widgets/recipe_compact_widget.dart';
import '../../../injection/service_locator.dart';
import '../../../router/app_router.dart';
import '../../user_profiles/data/model/user_model.dart';
import '../domain/favorite_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;
    final UserModel userModel = user != null
        ? UserModel(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName,
            photoURL: user.photoURL,
          )
        : UserModel(
            uid: '-',
            email: '-',
            displayName: 'Anonymous',
            photoURL: '',
          );
    context.read<FavoriteBloc>().add(FetchFavorites());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            if (state.favoriteRecipes.isEmpty) {
              return const Center(child: Text('No Favorites Yet!'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0), // Add padding around the grid
              itemCount: state.favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = state.favoriteRecipes[index];
                return GestureDetector(
                  onTap: () {
                    context.pushRoute(RecipeDetailsRoute(recipe: recipe, userModel: userModel));
                  },
                  child: Hero(
                    tag: "recipe-${recipe.id}",
                    child: RecipeCompactWidget(recipe: recipe),
                  ),
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
