// lib/widgets/social_button.dart
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  /// Shows a spinner in place of the icon while this provider's sign-in is
  /// running. [enabled] is set false on the *other* buttons meanwhile, so a
  /// second provider can't be started mid-flow.
  final bool isLoading;
  final bool enabled;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }
    return IconButton(
      icon: Icon(icon, size: 32),
      color: enabled ? null : Colors.grey.shade400,
      onPressed: enabled ? onPressed : null,
    );
  }
}
