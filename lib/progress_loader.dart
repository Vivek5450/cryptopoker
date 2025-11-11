import 'package:flutter/material.dart';

class PokerLoader extends StatelessWidget {
  final bool isLoading;

  const PokerLoader({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        // Dim background overlay
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        // Centered GIF loader
        Center(
          child: SizedBox(
            child: Image.asset(
              'assets/images/progess_loader.gif', // 🔹 replace with your gif path
              fit: BoxFit.contain,
              height: 150,
            ),
          ),
        ),
      ],
    );
  }
}
