import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGoogleSignIn; // To differentiate Google button style
  final Color? backgroundColor;
  final Color? textColor;
  final Color? foregroundColor; // Optional foreground color
  final IconData? leadingIcon; // Optional leading icon
  final IconData? trailingIcon; // Optional trailing icon

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGoogleSignIn = false,
    this.backgroundColor,
    this.textColor,
    this.foregroundColor,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor ??
            textColor ??
            _getTextColor(), // Use foregroundColor first, then textColor
        backgroundColor: backgroundColor ??
            _getBackgroundColor(), // Background color or default
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 16), // Adjust vertical padding for better height
        elevation: 5, // Light shadow effect for elevation
        shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // If Google Sign-In, use Google logo as the leading icon
          if (isGoogleSignIn)
            Icon(MdiIcons.google,
                size: 20,
                color: foregroundColor ?? textColor ?? _getTextColor())
          else if (leadingIcon != null)
            Icon(leadingIcon,
                size: 20,
                color: foregroundColor ?? textColor ?? _getTextColor()),
          if (leadingIcon != null || isGoogleSignIn) const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          if (trailingIcon != null) const SizedBox(width: 8),
          if (trailingIcon != null)
            Icon(
              trailingIcon,
              size: 20,
              color: foregroundColor ?? textColor ?? _getTextColor(),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isGoogleSignIn) {
      return Colors.white; // White background for Google sign-in
    } else {
      return Colors.blue; // Default primary color for the Auth buttons
    }
  }

  Color _getTextColor() {
    if (isGoogleSignIn) {
      return Colors.black; // Black text for Google sign-in
    } else {
      return Colors.white; // White text for normal Auth buttons
    }
  }
}
