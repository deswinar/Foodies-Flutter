import 'dart:io';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String
      source; // The source of the image, e.g., publicId or URL or local file path
  final double size; // Diameter of the circular image
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool
      useCloudinary; // Flag to toggle between Cloudinary or another source

  const ProfileImageWidget({
    super.key,
    required this.source,
    this.size = 100,
    this.placeholder,
    this.errorWidget,
    this.useCloudinary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useCloudinary) {
      // Render a Cloudinary image in a circular widget
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: CldImageWidget(
            publicId: source,
            transformation: Transformation()
              ..resize(Resize.fill()
                ..width(size.toInt())
                ..height(size.toInt())),
            placeholder: (context, _) {
              return placeholder ??
                  const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
                errorWidget ?? const Icon(Icons.account_circle, size: 50),
          ),
        ),
      );
    } else {
      // Check if source is a URL or local file path
      bool isUrl = Uri.tryParse(source)?.hasAbsolutePath ?? false;
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: isUrl
              ? Image.network(
                  source,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return placeholder ??
                        const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      errorWidget ?? const Icon(Icons.account_circle, size: 50),
                )
              : Image.file(
                  File(source),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      errorWidget ?? const Icon(Icons.account_circle, size: 50),
                ),
        ),
      );
    }
  }
}
