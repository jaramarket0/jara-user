import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showCart;
  final VoidCallback? onBackPressed;

  const AppHeader({
    Key? key,
    required this.title,
    this.showCart = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (onBackPressed != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showCart)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Implement cart navigation
              },
            ),
        ],
      ),
    );
  }
}

