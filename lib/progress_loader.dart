import 'package:flutter/material.dart';
import 'dart:math' as math;

class PokerLoader extends StatefulWidget {
  final bool isLoading;

  const PokerLoader({super.key, required this.isLoading});

  @override
  State<PokerLoader> createState() => _PokerLoaderState();
}

class _PokerLoaderState extends State<PokerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        // Dim background overlay
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        // Centered poker loader
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Colors.redAccent, Colors.black],
                      radius: 0.9,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ..._buildSymbols(),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "♠️",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.redAccent,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSymbols() {
    const symbols = ["♠", "♥", "♦", "♣"];
    const double radius = 45;
    return List.generate(symbols.length, (i) {
      final angle = (i / symbols.length) * 2 * math.pi;
      return Transform.translate(
        offset: Offset(
          radius * math.cos(angle),
          radius * math.sin(angle),
        ),
        child: Text(
          symbols[i],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}
