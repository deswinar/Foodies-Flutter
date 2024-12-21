import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ThumbnailPickerEdit extends StatelessWidget {
  final String? thumbnail; // File path or URL of the thumbnail image
  final Function(String) onThumbnailSelected;

  const ThumbnailPickerEdit({
    super.key,
    this.thumbnail,
    required this.onThumbnailSelected,
  });

  Future<void> _pickThumbnail(BuildContext context) async {
    final picker = ImagePicker();

    // Show modal to select image source
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              final pickedImage =
                  await picker.pickImage(source: ImageSource.camera);
              if (pickedImage != null) {
                onThumbnailSelected(pickedImage.path); // Return the file path
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final pickedImage =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                onThumbnailSelected(pickedImage.path); // Return the file path
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thumbnail",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickThumbnail(context),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              image: thumbnail != null
                  ? DecorationImage(
                      image: _isValidUrl(thumbnail!)
                          ? NetworkImage(
                              thumbnail!) // Use NetworkImage for URLs
                          : FileImage(File(thumbnail!))
                              as ImageProvider, // FileImage for local paths
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: thumbnail == null
                ? const Center(
                    child: Icon(Icons.add_photo_alternate,
                        color: Colors.grey, size: 50),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

bool _isValidUrl(String path) {
  Uri uri = Uri.tryParse(path) ?? Uri();
  return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
}
