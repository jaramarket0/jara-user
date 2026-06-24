import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;
  final bool showMostOrdered;

  const FoodCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
    this.showMostOrdered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.3,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          name.length > 10
                              ? '${name.substring(0, 10)}...'
                              : name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text('3.5k Ordered', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            if (!showMostOrdered)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '3.5k Ordered',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            // Positioned(
            //   top: 1,
            //   right: 1,
            //   child: Container(

            //     decoration: BoxDecoration(
            //       color: Color(0xffFFFFFF).withValues(alpha: .64),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: IconButton(
            //       icon: Icon(
            //         isFavorite ? Icons.favorite : Icons.favorite_border,
            //         color: isFavorite ? Colors.red : Color(0xff6B7280),
            //       ),
            //       onPressed: onFavoritePressed,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
