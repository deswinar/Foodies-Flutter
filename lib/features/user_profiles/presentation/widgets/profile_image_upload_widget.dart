import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageUploadWidget extends StatefulWidget {
  final Function(XFile?) onImageUpdated;
  final String? existingImageUrl; // Optional parameter for an existing image URL

  const ProfileImageUploadWidget({
    super.key,
    required this.onImageUpdated,
    this.existingImageUrl,
  });

  @override
  _ProfileImageUploadWidgetState createState() =>
      _ProfileImageUploadWidgetState();
}

class _ProfileImageUploadWidgetState
    extends State<ProfileImageUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    // Initialize with an existing image URL if provided
    if (widget.existingImageUrl != null) {
      _profileImage = XFile(widget.existingImageUrl!);
    }
  }

  Future<void> _pickImage({required ImageSource source}) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
        widget.onImageUpdated(_profileImage);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
      widget.onImageUpdated(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              await _pickImage(source: ImageSource.camera);
            } else if (action == 'gallery') {
              await _pickImage(source: ImageSource.gallery);
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage: _profileImage != null
                ? (kIsWeb || Uri.parse(_profileImage!.path).isAbsolute
                    ? NetworkImage(_profileImage!.path)
                    : FileImage(File(_profileImage!.path))) as ImageProvider
                : null,
            child: _profileImage == null
                ? const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.grey,
                  )
                : null,
          ),
        ),
        if (_profileImage != null)
          TextButton.icon(
            onPressed: _removeImage,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
