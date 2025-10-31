
import 'package:cryptopoker/welcome_screen.dart';
import 'package:cryptopoker/dashboard_view.dart';
import 'package:cryptopoker/game_variant_selection.dart';
import 'package:cryptopoker/lets_play_screen.dart';
import 'package:cryptopoker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Poker Demo',
      getPages: [
        GetPage(name: '/welcomescreen', page: () => const WelcomeScreen()),
        GetPage(name: '/letsplay', page: () => const LetPlayView()),
        GetPage(name: '/game_variant', page: () => const GameVariantSelectionView()),
        GetPage(name: '/dashboard', page: () => const DashboardView()),
      ],
      home: SplashScreen(),
    );
  }
}
