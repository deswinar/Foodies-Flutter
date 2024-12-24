import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/recipe_compact_widget.dart';
import '../../../../injection/service_locator.dart';
import '../../../../router/app_router.dart';
import '../../../recipes/data/model/recipe_model.dart';
import '../../domain/feeds/featured_feed_bloc.dart';
import '../../domain/feeds/feed_bloc.dart';
import '../../domain/feeds/feed_event.dart';
import '../../domain/feeds/feed_state.dart';
import '../../../../core/constants.dart';

class FeedWidget extends StatelessWidget {
  final User? user;

  const FeedWidget({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedsLoadedState) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter == 0) {
                context.read<FeedBloc>().add(FetchFeedsEvent(
                    category: state.category, sortBy: state.sortBy));
              }
              return false;
            },
            child: ListView(
              children: [
                _buildCategoryTabs(context, state),
                _buildFeaturedRecipesSection(context),
                _buildAllRecipes(context, state.recipes, user),
              ],
            ),
          );
        } else if (state is FeedsErrorState) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: Text('No recipes available.'));
        }
      },
    );
  }

  Widget _buildCategoryTabs(BuildContext context, FeedsLoadedState state) {
    final selectedCategory = state.category;
    final currentSortBy = state.sortBy;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (isSelected) {
                final feedBloc = context.read<FeedBloc>();
                if (isSelected && selectedCategory != category) {
                  feedBloc.add(FetchFeedsEvent(
                      category: category, sortBy: currentSortBy));
                } else if (!isSelected && selectedCategory != null) {
                  feedBloc.add(
                      FetchFeedsEvent(category: null, sortBy: currentSortBy));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedRecipesSection(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeaturedFeedBloc>()..add(FetchFeaturedFeedsEvent()),
      child: BlocBuilder<FeaturedFeedBloc, FeaturedFeedState>(
        builder: (context, state) {
          if (state is FeaturedFeedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeaturedFeedLoaded) {
            return _buildFeaturedRecipes(context, state.featuredRecipes);
          } else if (state is FeaturedFeedError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeaturedRecipes(BuildContext context, List<Recipe> recipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(
            'Featured Recipes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length > 5 ? 5 : recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  context.pushRoute(RecipeDetailsRoute(
                      recipe: recipe, userModel: recipe.user!));
                },
                child: Hero(
                  tag: "recipe-${recipe.id}",
                  child: Card(
                    child: Column(
                      children: [
                        recipe.thumbnailUrl.isNotEmpty
                            ? Image.network(
                                recipe.thumbnailUrl,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholders/recipe_placeholder.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recipe.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllRecipes(
    BuildContext context,
    List<Recipe> recipes,
    User? user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(
            'All Recipes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                print(recipe.user!.displayName);
                context.pushRoute(RecipeDetailsRoute(
                    recipe: recipe, userModel: recipe.user!));
              },
              child: Hero(
                tag: "recipe-${recipe.id}",
                child: RecipeCompactWidget(
                    recipe: recipe), // Replaced with RecipeCompactWidget
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
