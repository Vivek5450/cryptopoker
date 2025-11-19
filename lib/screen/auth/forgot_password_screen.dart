import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
              Spacer(),
              Image.asset('assets/images/Logo.png', height: 90),
              const SizedBox(height: 100),
              Text(
                'Forget your Password?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildTextField(hintText: 'Email', borderColor: Colors.white30),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Reset Password',
                borderColor: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Back to Login Page',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              Spacer(),
              Text(
                'Don\'t have an Account?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/create_account.png',
                height: 60,
                width: double.infinity,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(14),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            hintText,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
