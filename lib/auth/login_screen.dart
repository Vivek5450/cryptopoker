import 'dart:ui';
import 'package:cryptopoker/auth/register_screen.dart';
import 'package:cryptopoker/controller/auth_controller.dart';
import 'package:cryptopoker/progress_loader.dart';
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
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2A900).withOpacity(0.7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF2A900), size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                const TextStyle(color: Color(0xFFF2A900), fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2A900),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: Colors.black54,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
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
          Image.asset('assets/images/login.png', fit: BoxFit.cover),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF2A900), width: 1),
                  ),
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),

          // 👇 Loader Overlay (appears when logging in)
          Obx(() => PokerLoader(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Welcome Back",
            style: TextStyle(
              color: Color(0xFFF2A900),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: controller.usernameController,
            hintText: 'Username',
            icon: Icons.person,
          ),
          _buildTextField(
            controller: controller.passwordController,
            hintText: 'Password',
            obscure: true,
            icon: Icons.lock,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Login', () {
                controller.login(
                  controller.usernameController.text.trim(),
                  controller.passwordController.text,
                );
              }),
              const SizedBox(width: 16),
              _buildButton('Register', () {
                Get.to(() => const RegisterScreen());
              }),
            ],
          ),
        ],
      ),
    );
  }

}
