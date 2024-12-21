import 'dart:io';
import 'package:flutter/material.dart';
import '../../../domain/services/image_picker_helper.dart';

class ThumbnailPicker extends StatelessWidget {
  final File? thumbnail;
  final ValueChanged<File?> onThumbnailSelected;

  const ThumbnailPicker({
    super.key,
    required this.thumbnail,
    required this.onThumbnailSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (thumbnail != null) Image.file(thumbnail!, height: 150),
        ElevatedButton.icon(
          onPressed: () async {
            final selectedImage = await ImagePickerHelper().showImagePickerOptions(context);
            if (selectedImage != null) {
              onThumbnailSelected(selectedImage);
            }
          },
          icon: const Icon(Icons.image),
          label: const Text('Change Thumbnail'),
        ),
      ],
    );
  }
}
