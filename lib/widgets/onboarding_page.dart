import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;

  const OnboardingPage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}