import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/profile_image_widget.dart';
import '../../../core/common/widgets/recipe_compact_widget.dart';
import '../../../router/app_router.dart';
import '../../auth/domain/auth_bloc.dart';
import '../../recipes/data/model/recipe_model.dart';
import '../data/model/user_model.dart';
import '../domain/follower/follower_bloc.dart';
import '../domain/following/following_bloc.dart';
import '../domain/profile/profile_bloc.dart';
import '../domain/user_recipes/user_recipes_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Text("Error: ${state.message}");
          } else if (state is ProfileLoaded) {
            final user = state.user;
            context
                .read<UserRecipeBloc>()
                .add(FetchUserRecipes(userModel: user));
            context
                .read<FollowingBloc>()
                .add(CountFollowings(userId: user!.uid));
            context.read<FollowerBloc>().add(CountFollowers(userId: user.uid));
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Profile Picture and Name
                  ProfileImageWidget(
                    initialSource:
                        user.photoURL!, // Cloudinary public ID or network URL
                    size: 100, // Circular size (diameter)
                    placeholder:
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: const Icon(Icons.account_circle, size: 80), // Toggle between Cloudinary or network image
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    user!.displayName ?? 'Anonymous',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(user.email ?? 'No Email',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16.0),

                  // Followings and Followers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocBuilder<FollowingBloc, FollowingState>(
                          builder: (context, state) {
                        if (state is CountFollowingsLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is CountFollowingsLoaded) {
                          return _buildStat(
                              context, 'Followings', state.count, user.uid);
                        } else {
                          return _buildStat(context, 'Followings', 0, user.uid);
                        }
                      }), // Placeholder
                      BlocBuilder<FollowerBloc, FollowerState>(
                          builder: (context, state) {
                        if (state is CountFollowersLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is CountFollowersLoaded) {
                          return _buildStat(
                              context, 'Followers', state.count, user.uid);
                        } else {
                          return _buildStat(context, 'Followers', 0, user.uid);
                        }
                      }),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle the edit profile action
                      context.pushRoute(EditProfileRoute(user: user));
                    },
                    child: const Text('Edit Profile'),
                  ),

                  Divider(thickness: 1.5, color: Colors.grey.shade300),
                  const SizedBox(height: 16.0),

                  // Uploaded Recipes (Grid View)
                  _buildSectionTitle('Your Recipes'),
                  BlocBuilder<UserRecipeBloc, UserRecipeState>(
                      builder: (context, state) {
                    if (state is UserRecipeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserRecipeLoaded) {
                      final uploadedRecipes = state.userRecipes;
                      return _buildGridRecipeList(uploadedRecipes, user);
                    } else if (state is UserRecipeError) {
                      return Text("Error: ${state.message}");
                    } else {
                      return const Placeholder();
                    }
                  }),

                  const SizedBox(height: 16.0),

                  // Sign Out Button
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoggedOut());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign Out',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else {
            return const Text('Unknown Error');
          }
        },
      ),
    );
  }

  Widget _buildGridRecipeList(List<Recipe> recipes, UserModel user) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length + 1,
      itemBuilder: (context, index) {
        if (index == recipes.length) {
          return GestureDetector(
            onTap: () {
              // Navigate to show all uploaded recipes
              context.pushRoute(UserRecipesRoute(userModel: user));
            },
            child: _buildShowAllCard(),
          );
        }
        final recipe = recipes[index];
        return GestureDetector(
            onTap: () {
              context.pushRoute(EditRecipeRoute(recipe: recipe)).then((result) {
                if (result != null && result is Recipe) {
                  context
                      .read<UserRecipeBloc>()
                      .add(UpdateUserRecipeEvent(recipe: result));
                }
              });
            },
            child: RecipeCompactWidget(
              recipe: recipe,
              showEdit: true,
              onRecipeUpdated: (updatedRecipe) {
                context
                    .read<UserRecipeBloc>()
                    .add(UpdateUserRecipeEvent(recipe: updatedRecipe));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recipe updated successfully!'),
                  ),
                );
              },
            ));
      },
    );
  }

  // Helper widget to display followings/followers stats with gesture detection
  Widget _buildStat(
      BuildContext context, String label, int count, String userId) {
    return GestureDetector(
      onTap: () {
        // Navigate to the appropriate list screen based on the label
        context.pushRoute(UserListRoute(userId: userId, title: label));
      },
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }

  // Helper widget to display section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper widget for "Show All" card
  Widget _buildShowAllCard() {
    return Card(
      color: Colors.grey[200],
      child: const Center(
        child: Text(
          'Show All',
          style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
