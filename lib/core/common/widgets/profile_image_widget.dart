// Suggested code may be subject to a license. Learn more: ~LicenseLog:808180350.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:998860799.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2735373682.
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? initialSource; // The initial source of the image
  final double size; // Diameter of the circular image
  final Widget? placeholder;
  final Widget? errorWidget;

  const ProfileImageWidget({
    super.key,
    this.initialSource,
    this.size = 100,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.initialSource != null) {
      _imageFile = XFile(widget.initialSource!);
    }
    // You might want to load the initial image here if it's from a network source
  }

  @override
  Widget build(BuildContext context) {
    final source = _imageFile ?? widget.initialSource;

    if (source == null) {
      return ClipOval(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child:
              widget.placeholder ?? const Icon(Icons.account_circle, size: 50),
        ),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: kIsWeb || Uri.tryParse(_imageFile!.path)?.isAbsolute == true
            ? Image.network(
                _imageFile!.path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    widget.errorWidget ??
                    const Icon(Icons.account_circle, size: 50),
              )
            : Image.file(
                File(_imageFile!.path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    widget.errorWidget ??
                    const Icon(Icons.account_circle, size: 50),
              ),
      ),
    );
  }
}
