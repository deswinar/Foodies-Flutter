import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';

class RecipeImageWidget extends StatelessWidget {
  final String source; // The source of the image, e.g., publicId or URL
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool
      useCloudinary; // Flag to toggle between Cloudinary or another source

  const RecipeImageWidget({
    super.key,
    required this.source,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.useCloudinary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (useCloudinary) {
      // Render a Cloudinary image
      return SizedBox(
        width: width,
        height: height,
        child: CldImageWidget(
          publicId: source,
          transformation: Transformation()
            ..resize(Resize.fill()
              ..width(width.toInt())
              ..height(height.toInt())),
          placeholder: (context, _) => placeholder ??
                const Icon(Icons.broken_image),
          errorBuilder: (context, error, stackTrace) =>
              errorWidget ?? const Icon(Icons.broken_image),
        ),
      );
    } else {
      // Fallback to network or local image
      return SizedBox(
        width: width,
        height: height,
        child: Image.network(
          source,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ??
                const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) =>
              errorWidget ?? const Icon(Icons.broken_image),
        ),
      );
    }
  }
}
