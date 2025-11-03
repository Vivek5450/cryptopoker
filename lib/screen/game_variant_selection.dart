import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameVariantSelectionView extends StatelessWidget {
  const GameVariantSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final variants = [
      {'title': 'Texas Hold’em', 'image': 'assets/images/texas.png'},
      {'title': 'Omaha', 'image': 'assets/images/omaha.png'},
      {'title': 'Seven Card Stud', 'image': 'assets/images/sevenstud.png'},
      {'title': 'High Stakes Royale', 'image': 'assets/images/highstakes.png'},
    ];

    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/black_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD27F), Color(0xFFF2A900)],
                ).createShader(bounds),
                child: const Text(
                  'Select Your Game Variant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Responsive poker variant cards
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 40,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                    children: variants.map((variant) {
                      return GestureDetector(
                        onTap: () {
                          Get.offNamed('/dashboard', arguments: variant['title']);
                        },
                        child: Container(
                          width: isLandscape ? size.width * 0.18 : size.width * 0.35,
                          height: isLandscape ? size.height * 0.55 : size.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE39A), Color(0xFFF2A900)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    variant['image']!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error, color: Colors.red, size: 50);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  variant['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'CormorantGaramond',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
