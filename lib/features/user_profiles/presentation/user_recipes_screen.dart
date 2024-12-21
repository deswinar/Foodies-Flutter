import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/user_profiles/data/model/user_model.dart';
import 'package:myapp/features/user_profiles/domain/user_recipes/user_recipes_bloc.dart';
import 'package:myapp/router/app_router.dart';

import '../../../core/common/widgets/recipe_widget.dart';

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

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio:
                    3 / 4, // Width-to-height ratio of each grid item
              ),
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
                    child: RecipeWidget(
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
