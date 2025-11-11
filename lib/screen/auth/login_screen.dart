import 'dart:ui';
import 'package:cryptopoker/screen/auth/register_screen.dart';
import 'package:cryptopoker/controller/auth_controller.dart';
import 'package:cryptopoker/progress_loader.dart';
import 'package:cryptopoker/screen/dashboard/dashboard_view.dart';
import 'package:cryptopoker/screen/lobby/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscure = false,
    String? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Colors.white30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(width: 10),
              Image.asset(icon!, height: 28),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 190, 37, 35), // light red (top)
              Color.fromARGB(255, 144, 20, 22),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // your background and login form
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo.png', height: 90),
              SizedBox(height: 40),
              _buildTextField(
                controller: controller.usernameController,
                hintText: 'Email',
                icon: 'assets/images/email.png',
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: controller.passwordController,
                hintText: 'Password',
                icon: 'assets/images/password.png',
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Sign in', () {
                   Get.to(()=>LobbyView());
                  }),
                  _buildButton('Register', () {
                    Get.to(()=>RegisterScreen());
                  }),
                ],
              ),
            ],
          ),
          // 👇 Loader Overlay (appears when logging in)
          Obx(() => PokerLoader(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }
}
