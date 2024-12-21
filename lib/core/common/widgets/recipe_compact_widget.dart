import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'like_button.dart';
import '../../../injection/service_locator.dart';
import '../../../features/recipes/data/model/recipe_model.dart';
import '../bloc/like/like_bloc.dart';
import 'recipe_action_bottom_drawer.dart';

class RecipeCompactWidget extends StatelessWidget {
  final Recipe recipe;
  final bool showEdit;
  final ValueChanged<Recipe>? onRecipeUpdated;

  const RecipeCompactWidget({
    super.key,
    required this.recipe,
    this.showEdit = false,
    this.onRecipeUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final user = getIt<FirebaseAuth>().currentUser;
    final currentUserId = user?.uid ?? '';

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10.0)),
            child: recipe.thumbnailUrl.isNotEmpty
                ? Image.network(
                    recipe.thumbnailUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholders/recipe_placeholder.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10.0),
          // Recipe Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: [
                      _buildTag(
                        text: recipe.category,
                        color: Colors.blue.shade50,
                        textColor: Colors.blue.shade700,
                      ),
                      _buildTag(
                        text: recipe.country,
                        color: Colors.green.shade50,
                        textColor: Colors.green.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundImage: recipe?.user?.photoURL != null
                            ? NetworkImage(recipe.user!.photoURL!)
                            : null,
                        child: recipe?.user?.photoURL == null
                            ? const Icon(Icons.person, size: 16.0)
                            : null,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          recipe.user?.displayName ?? 'Anonymous',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Like and More Actions
          Column(
            children: [
              BlocProvider(
                create: (_) => getIt<LikeBloc>()
                  ..add(FetchLikeStatus(recipe.id)),
                child: BlocBuilder<LikeBloc, LikeState>(
                  builder: (context, likeState) {
                    if (likeState is LikeLoading) {
                      return const CircularProgressIndicator(strokeWidth: 1.5);
                    } else if (likeState is LikeSuccess) {
                      return LikeButton(
                        recipe: recipe,
                        isLiked: likeState.isLiked,
                        onLikeToggled: () {
                          context.read<LikeBloc>().add(ToggleLike(recipe.id));
                        },
                      );
                    } else if (likeState is LikeError) {
                      return const Icon(Icons.error, color: Colors.red);
                    }
                    return const SizedBox();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                iconSize: 20.0,
                onPressed: () {
                  showRecipeActions(context, recipe,
                      showEdit: showEdit, onRecipeUpdated: onRecipeUpdated);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
