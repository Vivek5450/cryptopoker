import 'package:cryptopoker/screen/dashboard/dashboard_view.dart';
import 'package:cryptopoker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
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
        GetPage(name: '/dashboard', page: () => const DashboardView()),
      ],
      home: SplashScreen(),
    );
  }
}
