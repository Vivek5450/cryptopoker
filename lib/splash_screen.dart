import 'package:cryptopoker/screen/auth/login_screen.dart';
import 'package:cryptopoker/screen/dashboard/dashboard_view.dart';
import 'package:cryptopoker/token_storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Keep splash in portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future.delayed(Duration(seconds: 4), () {
      Get.offAll(() => LoginScreen());
    });
  }

  // Future<void> _checkLoginStatus() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   final token = await TokenStorage.getToken();
  //   if (token != null && token.isNotEmpty) {
  //     Get.offAllNamed('/letsplay');
  //   } else {
  //     Get.offAllNamed('/welcomescreen');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Center(child: Image.asset('assets/gif/splash_gif.gif')),
        ],
      ),
    );
  }
}
