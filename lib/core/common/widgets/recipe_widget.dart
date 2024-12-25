import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'like_button.dart';
import '../../../injection/service_locator.dart';
import '../../../features/recipes/data/model/recipe_model.dart';
import '../bloc/like/like_bloc.dart';
import 'profile_image_widget.dart';
import 'recipe_action_bottom_drawer.dart';
import 'recipe_image_widget.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final bool showEdit;
  final ValueChanged<Recipe>? onRecipeUpdated;

  const RecipeWidget(
      {super.key,
      required this.recipe,
      this.showEdit = false,
      this.onRecipeUpdated});

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;
    final currentUserId = user?.uid ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        double imageHeight = constraints.maxWidth * 0.5;
        double avatarRadius = constraints.maxWidth * 0.08;

        return Card(
          elevation: 4.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              RecipeImageWidget(
                source: recipe.thumbnailUrl, // Cloudinary public ID
                width: 250,
                height: 250,
                placeholder: const Center(child: CircularProgressIndicator()),
                errorWidget: const Center(child: Icon(Icons.error)),
                useCloudinary:
                    true, // Toggle this to false to use a network image.
              ),
              // Recipe Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: constraints.maxWidth * 0.05,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        _buildTag(
                          text: recipe.category,
                          color: Colors.blue.shade50,
                          textColor: Colors.blue.shade700,
                          fontSize: constraints.maxWidth * 0.04,
                        ),
                        _buildTag(
                          text: recipe.country,
                          color: Colors.green.shade50,
                          textColor: Colors.green.shade700,
                          fontSize: constraints.maxWidth * 0.04,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Divider(thickness: 1.5, color: Colors.grey.shade300),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        ProfileImageWidget(
                          initialSource: recipe.user?.photoURL ??
                              '', // Use photoURL if available; fallback to empty string
                          size:
                              avatarRadius * 2, // Diameter is twice the radius
                          placeholder: const Icon(Icons.person,
                              size: 50), // Icon for placeholder
                          errorWidget: const Icon(Icons.error,
                              size: 50),// Use Cloudinary only if photoURL is provided
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            recipe.user?.displayName ?? 'Anonymous',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: constraints.maxWidth * 0.04,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        BlocProvider(
                          create: (_) => getIt<LikeBloc>()
                            ..add(FetchLikeStatus(recipe.id)),
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
                                return const Icon(Icons.error,
                                    color: Colors.red);
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          iconSize: constraints.maxWidth * 0.07,
                          onPressed: () {
                            showRecipeActions(context, recipe,
                                showEdit: showEdit,
                                onRecipeUpdated: onRecipeUpdated);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag({
    required String text,
    required Color color,
    required Color textColor,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
