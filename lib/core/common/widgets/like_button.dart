// Suggested code may be subject to a license. Learn more: ~LicenseLog:3428394787.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:693979066.
import 'package:flutter/material.dart';

import '../../../features/recipes/data/model/recipe_model.dart';

class LikeButton extends StatelessWidget {
  final Recipe recipe;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onLikeToggled;

  const LikeButton({
    super.key,
    required this.recipe,
    required this.isLiked,
    required this.likeCount,
    required this.onLikeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: onLikeToggled,
          tooltip: isLiked ? 'Unlike' : 'Like',
        ),
        Text('$likeCount'),
        const SizedBox(width: 10,),
      ],
    );
  }
}
