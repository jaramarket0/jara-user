import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const PageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    this.activeColor = Colors.grey,
    this.inactiveColor = const Color(0xFFDDDDDD),
    this.dotSize = 8.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = index == currentIndex;

    // For the active dot, we'll use a different style
    if (isActive) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: spacing / 2),
        width: dotSize * 3, // Make active dot wider
        height: dotSize,
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(dotSize / 2),
        ),
      );
    }

    // For inactive dots
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: inactiveColor,
        shape: BoxShape.circle,
      ),
    );
  }
}