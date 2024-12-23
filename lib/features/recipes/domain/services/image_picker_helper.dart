import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<dynamic> pickImage(BuildContext context, ImageSource source) async {
    // Handle web and non-web cases separately
    if (kIsWeb) {
      final pickedFile = await _imagePicker.pickImage(source: source);
      return pickedFile != null ? pickedFile : null; // On web, return XFile
    } else {
      final pickedFile = await _imagePicker.pickImage(source: source);
      return pickedFile != null ? File(pickedFile.path) : null; // On other platforms, return File
    }
  }

  Future<dynamic> showImagePickerOptions(BuildContext context) async {
    dynamic selectedFile;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  selectedFile = await pickImage(context, ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture from Camera'),
                onTap: () async {
                  selectedFile = await pickImage(context, ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedFile;
  }
}
