// lib/features/recipes/presentation/widgets/recipe_ingredients_section.dart

import 'package:flutter/material.dart';

class RecipeIngredientsSection extends StatelessWidget {
  final List<String> ingredients;

  const RecipeIngredientsSection({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((ingredient) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "• $ingredient",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
