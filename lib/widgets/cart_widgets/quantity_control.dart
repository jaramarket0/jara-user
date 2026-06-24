import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decrement button
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(18),
          ),
          child: IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: onDecrement,
            padding: EdgeInsets.zero,
          ),
        ),

        // Quantity display
        Container(
          width: 36,
          alignment: Alignment.center,
          child: Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Increment button
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800), // Orange
            borderRadius: BorderRadius.circular(18),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            onPressed: onIncrement,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

