import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    Key? key,
    required this.imagePath,
    required this.name,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.grey.shade50 : Colors.white,
        ),
        child: Image.asset(
          imagePath,
          height: 24,
          width: 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

