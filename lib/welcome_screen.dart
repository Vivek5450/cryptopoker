import 'package:cryptopoker/auth/login_screen.dart';
import 'package:cryptopoker/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/img_11.png',
            fit: BoxFit.cover,
          ),
          // Buttons at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40), // gap from bottom
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPokerButton(
                    context,
                    label: 'LOGIN',
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildPokerButton(
                    context,
                    label: 'REGISTER',
                    onPressed: () {
                      Get.to(() => const RegisterScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokerButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE6E6E6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
