
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class LetPlayView extends StatefulWidget {
  const LetPlayView({super.key});

  @override
  State<LetPlayView> createState() => _LetPlayViewState();
}

class _LetPlayViewState extends State<LetPlayView> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]

    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _isLoading ? _buildLoading() : _buildContent(size),
        ),
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome to Crypto Poker',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'CormorantGaramond',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            foreground: Paint()..shader = const LinearGradient(
              colors: [Color(0xFFFFD27F), Color(0xFFF2A900)],
            ).createShader(const Rect.fromLTWH(0, 0, 300, 0)),
            shadows: const [
              Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(3,3)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () {
            setState(() => _isLoading = true);
            // simulate loading then navigate
            Future.delayed(const Duration(seconds: 3), () {
              Get.offNamed('/dashboard');
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFE39A), Color(0xFFF2A900)]),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 18, offset: const Offset(0,8)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.local_play, color: Colors.black),
                SizedBox(width: 12),
                Text("Let's Play", style: TextStyle(fontFamily: 'CormorantGaramond', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rotating poker chip
        SizedBox(
          width: 140,
          height: 140,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: Image.asset('assets/images/img_3.png'),
          ),
        ),
        const SizedBox(height: 18),
        // Rich linear progress indicator with rounded bar
        Container(
          width: 360,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0,3))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 18,
              valueColor: AlwaysStoppedAnimation(const Color(0xFFFFD27F)),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Getting ready...', style: TextStyle(fontFamily: 'CormorantGaramond', color: Colors.white70)),
      ],
    );
  }
}



// Add this inside _LetPlayViewState class (after _buildLoading):
List<Widget> _floatingCards(Size size) {
  final random = Random();
  return List.generate(5, (index) {
    final left = random.nextDouble() * size.width;
    final top = random.nextDouble() * size.height;
    final duration = Duration(seconds: 5 + random.nextInt(5));
    return AnimatedPositioned(
      duration: duration,
      left: left,
      top: top,
      child: Opacity(
        opacity: 0.3,
        child: Text(
          ['♠','♥','♦','♣'][random.nextInt(4)],
          style: TextStyle(fontSize: 48, color: Colors.white70, fontFamily: 'CormorantGaramond'),
        ),
      ),
    );
  });
}
