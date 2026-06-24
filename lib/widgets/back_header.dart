import 'package:flutter/material.dart';

class BackHeader extends StatelessWidget {
  final String title;
  final Color titleColor;

  const BackHeader({
    Key? key,
    required this.title,
    this.titleColor = Colors.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }
}

