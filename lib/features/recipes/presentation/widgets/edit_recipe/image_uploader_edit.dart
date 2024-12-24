import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/services/image_picker_helper.dart';

class ImageUploaderEdit extends StatelessWidget {
  final List<dynamic>
      uploadedImages; // List can hold any type (XFile, File, etc.)
  final Function(dynamic) onImagePicked; // Callback when a new image is added
  final Function(dynamic) onImageRemoved; // Callback to remove an image
  final VoidCallback onClearImages; // Callback to clear all images

  const ImageUploaderEdit({
    super.key,
    required this.uploadedImages,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onClearImages,
  });

  Future<void> _pickImage(BuildContext context) async {
    // Show dialog to choose between Gallery or Camera
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    // If user selects a source, open the image picker
    if (source != null) {
      final pickedImage = await _showImagePicker(context);

      if (pickedImage != null) {
        onImagePicked(pickedImage); // Return the picked image (XFile or File)
      }
    }
  }

  bool _isValidUrl(String path) {
    Uri uri = Uri.tryParse(path) ?? Uri();
    return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final pickedImage = await _showImagePicker(context);
                if (pickedImage != null) {
                  onImagePicked(pickedImage);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Image"),
            ),
            const SizedBox(width: 10),
            if (uploadedImages.isNotEmpty)
              ElevatedButton.icon(
                onPressed: onClearImages,
                icon: const Icon(Icons.clear_all),
                label: const Text("Clear All"),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Display uploaded images
        uploadedImages.isNotEmpty
            ? Wrap(
                spacing: 10,
                runSpacing: 10,
                children: uploadedImages.map((imagePath) {
                  bool isUrl =
                      Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isUrl
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onImageRemoved(imagePath),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
            : const Center(
                child: Text(
                  "No images uploaded yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ],
    );
  }

  Future<dynamic> _showImagePicker(BuildContext context) async {
    final selectedImage =
        await ImagePickerHelper().showImagePickerOptions(context);
    return selectedImage; // Return the selected image (either XFile or File)
  }
}
