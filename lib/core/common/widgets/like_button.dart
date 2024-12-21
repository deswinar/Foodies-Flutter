import 'package:flutter/material.dart';

import '../../../features/recipes/data/model/recipe_model.dart';

class LikeButton extends StatelessWidget {
  final Recipe recipe;
  final bool isLiked;
  final VoidCallback onLikeToggled;

  const LikeButton({
    super.key,
    required this.recipe,
    required this.isLiked,
    required this.onLikeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: onLikeToggled,
      tooltip: isLiked ? 'Unlike' : 'Like',
    );
  }
}
