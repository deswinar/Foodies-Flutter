import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/recipe_compact_widget.dart';
import '../../../router/app_router.dart';
import '../data/model/user_model.dart';
import '../domain/user_recipes/user_recipes_bloc.dart';

@RoutePage()
class UserRecipesScreen extends StatelessWidget {
  final UserModel userModel;
  const UserRecipesScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    context.read<UserRecipeBloc>().add(FetchUserRecipes(userModel: userModel));
    return Scaffold(
      appBar: AppBar(
        title: Text('${userModel.displayName ?? 'Anonymous'} Recipes'),
      ),
      body: BlocBuilder<UserRecipeBloc, UserRecipeState>(
        builder: (context, state) {
          if (state is UserRecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserRecipeLoaded) {
            if (state.userRecipes.isEmpty) {
              return const Center(child: Text('No Favorites Yet!'));
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0), // Add padding around the grid
              itemCount: state.userRecipes.length,
              itemBuilder: (context, index) {
                final recipe = state.userRecipes[index];
                return GestureDetector(
                  onTap: () {
                    context.pushRoute(RecipeDetailsRoute(
                        recipe: recipe, userModel: userModel));
                  },
                  child: Hero(
                    tag: "recipe-${recipe.id}",
                    child: RecipeCompactWidget(
                      recipe: recipe,
                      showEdit: true,
                    ),
                  ),
                );
              },
            );
          } else if (state is UserRecipeError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
