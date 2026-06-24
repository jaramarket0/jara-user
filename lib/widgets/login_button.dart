// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Change to nullable VoidCallback
  final bool isOutlined;
  final Color color;

  const LoginButton({
    Key? key,
    required this.text,
    required this.onPressed, // Still required, but can be null
    this.isOutlined = false,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, // ElevatedButton accepts nullable callbacks
        style: ElevatedButton.styleFrom(
          foregroundColor: isOutlined ? Theme.of(context).primaryColor : Colors.white,
          backgroundColor: isOutlined ? Colors.white : color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isOutlined
                ? BorderSide(color: Theme.of(context).primaryColor)
                : BorderSide.none,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}