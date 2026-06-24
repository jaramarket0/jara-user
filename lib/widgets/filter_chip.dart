import 'package:flutter/material.dart';

class FilterChip extends StatelessWidget {
  final String label;
  final bool hasDropdown;
  final VoidCallback onTap;

  const FilterChip({
    Key? key,
    required this.label,
    this.hasDropdown = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down),
            ],
          ],
        ),
      ),
    );
  }
}

