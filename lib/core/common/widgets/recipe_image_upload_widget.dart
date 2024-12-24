import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(List<XFile>) onImagesUpdated;
  final List<String>? existingImageUrls; // Optional parameter for existing images

  const ImageUploadWidget({
    super.key,
    required this.onImagesUpdated,
    this.existingImageUrls,
  });

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    // Initialize with existing image URLs if provided
    if (widget.existingImageUrls != null) {
      _images = widget.existingImageUrls!
          .map((url) => XFile(url)) // Convert URLs to XFile objects
          .toList();
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.take(5 - _images.length));
        widget.onImagesUpdated(_images);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (_images.length < 5) {
          _images.add(pickedFile);
          widget.onImagesUpdated(_images);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      widget.onImagesUpdated(_images);
    });
  }

  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      final XFile image = _images.removeAt(oldIndex);
      _images.insert(newIndex, image);
      widget.onImagesUpdated(_images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              children: _images.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;
                return Container(
                  key: ValueKey(image.path),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      kIsWeb || Uri.parse(image.path).isAbsolute
                          ? Image.network(
                              image.path,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                _reorderImages(oldIndex, newIndex);
              },
            ),
          ),
          if (_images.length < 5)
            GestureDetector(
              onTap: () async {
                final action = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Take Photo'),
                        onTap: () => Navigator.pop(context, 'camera'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () => Navigator.pop(context, 'gallery'),
                      ),
                    ],
                  ),
                );
                if (action == 'camera') {
                  await _pickImageFromCamera();
                } else if (action == 'gallery') {
                  await _pickImages();
                }
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
