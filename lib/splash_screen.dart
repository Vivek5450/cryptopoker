import 'package:cryptopoker/screen/dashboard/dashboard_view.dart';
import 'package:cryptopoker/screen/lets_play_screen.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // After delay, lock to landscape and move to Dashboard
    Future.delayed(const Duration(seconds: 3), ()  {

      Get.offAllNamed('/welcomescreen');

    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Image(
          image: AssetImage('assets/images/splash_screen.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
