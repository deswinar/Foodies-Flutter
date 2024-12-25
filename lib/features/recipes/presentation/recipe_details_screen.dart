import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection/service_locator.dart';
import '../../user_profiles/data/model/user_model.dart';
import '../data/model/recipe_model.dart';
import '../../../core/common/bloc/like/like_bloc.dart';
import '../domain/recipe/recipe_bloc.dart';
import 'widgets/sections/comment_section.dart';
import '../../../core/common/widgets/like_button.dart';
import 'widgets/sections/follow_recipe_creator_section.dart';
import 'widgets/sections/recipe_ingredients_section.dart';
import 'widgets/sections/recipe_steps_section.dart';

@RoutePage()
class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  final UserModel userModel;

  const RecipeDetailsScreen(
      {super.key, required this.recipe, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;
    print(userModel.displayName);

    context.read<RecipeBloc>().add(FetchRecipeByIdEvent(recipeId: recipe.id));

    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      if (state is RecipeLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RecipeLoadedState) {
        final recipe = state.recipe;

        // Combine thumbnailUrl and imageUrls into one list
        final imageUrls = [recipe.thumbnailUrl, ...recipe.imageUrls];
        return Hero(
          tag: "recipe-${recipe.id}",
          child: Scaffold(
            appBar: AppBar(
              title: Text(recipe.title),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250.0,
                    child: CarouselView(
                      itemExtent: MediaQuery.sizeOf(context).width - 32,
                      itemSnapping: true,
                      elevation: 4,
                      padding: const EdgeInsets.all(8),
                      children: imageUrls.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250.0,
                                )
                              : Image.asset(
                                  'assets/images/placeholders/recipe_placeholder.png',
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recipe title and Like button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Recipe title
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Like button and like count
                      BlocProvider(
                        create: (_) =>
                            getIt<LikeBloc>()..add(FetchLikeStatus(recipe.id)),
                        child: BlocBuilder<LikeBloc, LikeState>(
                          builder: (context, likeState) {
                            if (likeState is LikeLoading) {
                              return const CircularProgressIndicator();
                            } else if (likeState is LikeSuccess) {
                              return LikeButton(
                                recipe: recipe,
                                isLiked: likeState.isLiked,
                                onLikeToggled: () {
                                  // Trigger the like/unlike event
                                  context.read<LikeBloc>().add(ToggleLike(
                                        recipe.id,
                                      ));
                                },
                              );
                            } else if (likeState is LikeError) {
                              return Icon(Icons.error, color: Colors.red);
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Recipe description
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),

                  // Category and Country
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          recipe.category,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          recipe.country,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Portion and Cooking Time
                  Row(
                    children: [
                      // Portion
                      Row(
                        children: [
                          Icon(Icons.people,
                              size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 4),
                          Text(
                            "${recipe.portion}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),

                      // Cooking Time
                      Row(
                        children: [
                          Icon(Icons.timelapse,
                              size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 4),
                          Text(
                            "${recipe.cookingDuration} hours",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Separator
                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // Ingredients
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RecipeIngredientsSection(ingredients: recipe.ingredients),
                  const SizedBox(height: 16),

                  // Separator
                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // Steps
                  const Text(
                    "Steps",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RecipeStepsSection(steps: recipe.steps),
                  const SizedBox(height: 16),

                  // Separator
                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // Tags
                  const Text(
                    "Tags",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: recipe.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue.shade100,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Separator
                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16),

                  FollowRecipeCreatorSection(
                    userModel: userModel,
                  ),

                  const SizedBox(height: 16),

                  // Separator
                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  // Comments
                  const Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Add your comment widget here
                  SizedBox(
                    height: 300, // Fixed height for the comment section
                    child: CommentSection(
                        recipeId: recipe.id), // Include CommentSection
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (state is RecipeErrorState) {
        return Center(child: Text('Error: ${state.errorMessage}'));
      }
      return const Center(child: Text('No recipe found.'));
    });
  }
}
