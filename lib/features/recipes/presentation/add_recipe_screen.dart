import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
// Import constants
import '../../../core/common/widgets/recipe_image_upload_widget.dart';
import '../../../core/constants.dart';
import '../../../injection/service_locator.dart';
import '../data/model/recipe_model.dart';
import '../domain/recipe/recipe_bloc.dart';
import 'widgets/input_dialog.dart';
import 'widgets/interactive_list.dart';

@RoutePage()
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _portionController = TextEditingController();
  String? _cookingDuration;

  final List<String> _ingredients = [];
  final List<String> _steps = [];
  final List<String> _tags = [];
  File? _thumbnailImage;
  List<XFile> _uploadedImages = [];

  String? _selectedCategory;
  String? _selectedCountry;

  void _submitRecipe() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null || _selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Category and Country')),
        );
        return;
      }

      try {
        final user = getIt<FirebaseAuth>().currentUser;

        final recipe = Recipe(
          id: '', // Firestore will generate this
          userId: user!.uid,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrls: [],
          thumbnailUrl: '',
          youtubeVideoUrl: _youtubeUrlController.text.trim(),
          ingredients: _ingredients,
          steps: _steps,
          tags: _tags,
          category: _selectedCategory!, // New field
          country: _selectedCountry!, // New field
          portion: _portionController.text.trim(), // New field
          cookingDuration: _cookingDuration ?? '', // New field
          likesCount: 0,
          commentsCount: 0,
          shareCount: 0,
          createdAt: DateTime.now(),
        );

        context
            .read<RecipeBloc>()
            .add(AddRecipeEvent(recipe: recipe, imagesToAdd: _uploadedImages));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe added successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeAddingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding Recipe...')),
            );
          } else if (state is RecipeAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recipe added successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is RecipeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is RecipeLoadingState;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Thumbnail and Image Uploader
                  ImageUploadWidget(
                    onImagesUpdated: (images) {
                      // Handle the updated image list
                      print(
                          "Selected Images: ${images.map((e) => e.path).toList()}");
                      setState(() {
                        _uploadedImages = images;
                      });
                    },
                  ),
                  // Category Dropdown
                  DropdownSearch<String>(
                    items: (filter, infiniteScrollProps) => categories,
                    popupProps: const PopupProps.menu(
                      showSelectedItems: true,
                      fit: FlexFit.tight,
                    ),
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "Category",
                        hintText: "Select a category",
                      ),
                    ),
                    selectedItem: _selectedCategory,
                    onChanged: (value) => setState(() {
                      _selectedCategory = value;
                    }),
                    validator: (value) =>
                        value == null ? 'Category is required' : null,
                  ),
                  const SizedBox(height: 10),
                  // Country Dropdown
                  DropdownSearch<String>(
                    items: (filter, infiniteScrollProps) => countries,
                    popupProps: const PopupProps.menu(
                      showSelectedItems: true,
                      fit: FlexFit.tight,
                    ),
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "Country",
                        hintText: "Select a country",
                      ),
                    ),
                    selectedItem: _selectedCountry,
                    onChanged: (value) => setState(() {
                      _selectedCountry = value;
                    }),
                    validator: (value) =>
                        value == null ? 'Country is required' : null,
                  ),
                  const SizedBox(height: 10),
                  // Other Fields (YouTube URL, Title, Description)
                  TextFormField(
                    controller: _youtubeUrlController,
                    decoration: const InputDecoration(
                      labelText: 'YouTube Video URL (Optional)',
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !Uri.tryParse(value)!.isAbsolute) {
                        return 'Invalid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value?.trim().isEmpty == true
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value?.trim().isEmpty == true
                        ? 'Description is required'
                        : null,
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
                  InkWell(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialEntryMode:
                            TimePickerEntryMode.inputOnly, // Set to input only
                        builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!),
                        initialTime: const TimeOfDay(
                            hour: 0, minute: 15), // Initial time set to 00:15
                      );
                      if (pickedTime != null) {
                        setState(() {
                          // Manually format the time in 24-hour format
                          _cookingDuration =
                              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration:
                          const InputDecoration(labelText: 'Cooking Duration'),
                      child: Text(_cookingDuration ?? 'Select Time'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Interactive Lists (Ingredients, Steps, Tags)
                  InteractiveList(
                    label: 'Ingredients',
                    items: _ingredients,
                    onAdd: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) =>
                            const InputDialog(label: 'Ingredient'),
                      );
                      if (result != null && result.trim().isNotEmpty) {
                        setState(() {
                          _ingredients.add(result.trim());
                        });
                      }
                    },
                    onRemove: (index) {
                      setState(() {
                        _ingredients.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  InteractiveList(
                    label: 'Steps',
                    items: _steps,
                    onAdd: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => const InputDialog(label: 'Step'),
                      );
                      if (result != null && result.trim().isNotEmpty) {
                        setState(() {
                          _steps.add(result.trim());
                        });
                      }
                    },
                    onRemove: (index) {
                      setState(() {
                        _steps.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  InteractiveList(
                    label: 'Tags',
                    items: _tags,
                    onAdd: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => const InputDialog(label: 'Tag'),
                      );
                      if (result != null && result.trim().isNotEmpty) {
                        setState(() {
                          _tags.add(result.trim());
                        });
                      }
                    },
                    onRemove: (index) {
                      setState(() {
                        _tags.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitRecipe,
                          child: const Text('Submit Recipe'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
