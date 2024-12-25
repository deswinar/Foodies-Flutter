import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../features/recipes/data/model/recipe_model.dart';
import '../../../router/app_router.dart';

void showRecipeActions(
  BuildContext context,
  Recipe recipe, {
  bool showEdit = false,
  ValueChanged<Recipe>? onRecipeUpdated, // Callback for passing result
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      bool isNavigating = false;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showEdit)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Recipe'),
                onTap: () async {
                  if (isNavigating) return; // Prevent multiple presses
                  isNavigating = true;
                  Navigator.pop(context); // Close the modal
                  await Future.delayed(const Duration(milliseconds: 50));
                  // Navigate to Edit Screen
                  context
                      .pushRoute(EditRecipeRoute(recipe: recipe))
                      .then((result) {
                    if (result != null && result is Recipe) {
                      onRecipeUpdated?.call(result);
                    }
                  });
                  isNavigating = false;
                },
              ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Recipe'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                // Trigger share logic
                print('Share Recipe tapped');
              },
            ),
          ],
        ),
      );
    },
  );
}
