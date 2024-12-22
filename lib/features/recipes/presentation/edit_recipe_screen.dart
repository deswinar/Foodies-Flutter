// Suggested code may be subject to a license. Learn more: ~LicenseLog:1685030342.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/recipes/data/model/recipe_model.dart';
import 'package:myapp/features/recipes/domain/recipe/recipe_bloc.dart';
import 'package:myapp/features/recipes/presentation/widgets/edit_recipe/thumbnail_picker_edit.dart';
import 'package:myapp/features/recipes/presentation/widgets/interactive_list.dart';
import 'package:myapp/features/recipes/presentation/widgets/input_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Import constants
import 'package:myapp/core/constants.dart';

import '../domain/services/recipe_update_service.dart';
import 'widgets/edit_recipe/image_uploader_edit.dart';

@RoutePage()
class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe; // Pass the recipe details here

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _youtubeUrlController;
  late TextEditingController _portionController;

  String? _cookingDuration;
  String? _selectedCategory;
  String? _selectedCountry;

  String? _thumbnailImage;
  late List<String> _uploadedImages;
  late List<String> _ingredients;
  late List<String> _steps;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();

    // Initialize fields with existing data
    _titleController = TextEditingController(text: widget.recipe.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.recipe.description ?? '');
    _youtubeUrlController =
        TextEditingController(text: widget.recipe.youtubeVideoUrl ?? '');
    _portionController =
        TextEditingController(text: widget.recipe.portion ?? '');
    _cookingDuration = widget.recipe.cookingDuration ?? '';

    // Use file paths (String) for image URLs and thumbnail
    _uploadedImages = List<String>.from(widget.recipe.imageUrls);
    _thumbnailImage = widget.recipe.thumbnailUrl.isNotEmpty
        ? widget.recipe.thumbnailUrl
        : null;

    _selectedCategory = widget.recipe.category;
    _selectedCountry = widget.recipe.country;

    _ingredients = List<String>.from(widget.recipe.ingredients);
    _steps = List<String>.from(widget.recipe.steps);
    _tags = List<String>.from(widget.recipe.tags);
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<RecipeBloc>()
        .add(FetchRecipeByIdEvent(recipeId: widget.recipe.id));
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      if (state is RecipeInitialState) {
      } else if (state is RecipeUpdatingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RecipeErrorState) {
        return Center(child: Text('Error: ${state.errorMessage}'));
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Recipe'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (state is RecipeUpdatedState) {
                Navigator.of(context).pop(state.recipe); // Pass updated recipe
              } else {
                Navigator.of(context).pop(); // Default back navigation
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                // Add deletion confirmation dialog here
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Thumbnail & Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ThumbnailPickerEdit(
                  thumbnail: _thumbnailImage,
                  onThumbnailSelected: (file) {
                    setState(() {
                      _thumbnailImage = file;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ImageUploaderEdit(
                  uploadedImages: _uploadedImages,
                  onImagePicked: (file) {
                    setState(() {
                      _uploadedImages.add(file);
                      _thumbnailImage ??= _uploadedImages.first;
                    });
                  },
                  onImageRemoved: (path) {
                    print(_uploadedImages.length);
                    setState(() {
                      _uploadedImages.remove(path); // Remove specific image
                    });
                    print(_uploadedImages.length);
                  },
                  onClearImages: () {
                    setState(() {
                      _uploadedImages.clear();
                      _thumbnailImage = null;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Details'),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Recipe Title'),
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _portionController,
                  decoration: const InputDecoration(
                    labelText: 'Portion',
                    hintText: 'e.g., 2 servings, 1 loaf',
                  ),
                ),
                const SizedBox(height: 10),
                _buildTimePicker(),
                const SizedBox(height: 20),
                _buildSectionTitle('Category'),
                DropdownSearch<String>(
                  items: (filter, infiniteScrollProps) => categories,
                  popupProps: const PopupProps.menu(),
                  selectedItem: _selectedCategory,
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  validator: (value) =>
                      value == null ? 'Category is required' : null,
                ),
                const SizedBox(height: 10),
                _buildSectionTitle('Country'),
                DropdownSearch<String>(
                  items: (filter, infiniteScrollProps) => countries,
                  popupProps: const PopupProps.menu(),
                  selectedItem: _selectedCountry,
                  onChanged: (value) =>
                      setState(() => _selectedCountry = value),
                  validator: (value) =>
                      value == null ? 'Country is required' : null,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Steps & Ingredients'),
                InteractiveList(
                  label: 'Ingredients',
                  items: _ingredients,
                  onAdd: () => _addItemDialog('Ingredient', _ingredients),
                  onRemove: (index) =>
                      setState(() => _ingredients.removeAt(index)),
                ),
                const SizedBox(height: 10),
                InteractiveList(
                  label: 'Steps',
                  items: _steps,
                  onAdd: () => _addItemDialog('Step', _steps),
                  onRemove: (index) => setState(() => _steps.removeAt(index)),
                ),
                const SizedBox(height: 10),
                InteractiveList(
                  label: 'Tags',
                  items: _tags,
                  onAdd: () => _addItemDialog('Tag', _tags),
                  onRemove: (index) => setState(() => _tags.removeAt(index)),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    print(_thumbnailImage);
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        // Call the RecipeUpdateService to handle the update
                        final updateService = RecipeUpdateService();

                        final updatedRecipe = await updateService.updateRecipe(
                          oldRecipe: widget.recipe, // Pass the existing recipe
                          title: _titleController.text,
                          description: _descriptionController.text,
                          ingredients:
                              _ingredients, // Example: List of ingredients
                          steps: _steps, // Example: List of steps
                          tags: _tags, // Example: List of tags
                          newImages: _uploadedImages +
                              widget.recipe
                                  .imageUrls, // Combine new and old images
                          newThumbnail: _thumbnailImage ??
                              widget.recipe
                                  .thumbnailUrl, // New or existing thumbnail
                          youtubeVideoUrl: _youtubeUrlController.text,
                          category: _selectedCategory ?? '',
                          country: _selectedCountry ?? '',
                          portion: _portionController.text,
                          cookingDuration: _cookingDuration ?? '0',
                        );

                        context
                            .read<RecipeBloc>()
                            .add(UpdateRecipeEvent(recipe: updatedRecipe));

                        Navigator.of(context)
                            .pop(updatedRecipe); // Pass updated recipe
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }

  // Time Picker Widget
  Widget _buildTimePicker() {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 0, minute: 15),
        );
        if (pickedTime != null) {
          setState(() {
            _cookingDuration =
                '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Cooking Duration'),
        child: Text(_cookingDuration ?? 'Select Time'),
      ),
    );
  }

  // Add Item Dialog
  void _addItemDialog(String label, List<String> targetList) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => InputDialog(label: label),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() => targetList.add(result.trim()));
    }
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add delete functionality here
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
