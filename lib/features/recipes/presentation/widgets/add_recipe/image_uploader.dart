import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/recipes/domain/services/image_picker_helper.dart';

class ImageUploader extends StatelessWidget {
  final List<File> uploadedImages;
  final Function(File) onImagePicked;
  final VoidCallback onClearImages;
  final String placeholderPath;

  const ImageUploader({
    super.key,
    required this.uploadedImages,
    required this.onImagePicked,
    required this.onClearImages,
    this.placeholderPath = 'assets/images/placeholders/recipe_placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final selectedImage = await _showImagePicker(context);
            if (selectedImage != null) {
              onImagePicked(selectedImage);
            }
          },
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              image: uploadedImages.isEmpty
                  ? DecorationImage(
                      image: AssetImage(placeholderPath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: uploadedImages.isNotEmpty
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: uploadedImages.map((file) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  // Replace with the uploaded image URL for web
                                  'https://via.placeholder.com/150', // Temporary URL
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  file,
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    }).toList(),
                  )
                : Center(
                    child: Text(
                      'Tap to upload images',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
          ),
        ),
        if (uploadedImages.isNotEmpty)
          TextButton(
            onPressed: onClearImages,
            child: const Text('Clear Images'),
          ),
      ],
    );
  }

  Future<File?> _showImagePicker(BuildContext context) async {
    final selectedImage =
        await ImagePickerHelper().showImagePickerOptions(context);
    return selectedImage;
  }
}
