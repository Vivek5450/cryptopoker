import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboard_controller.dart';
import 'widgets/poker_table.dart';
import 'widgets/dealer_badge.dart';
import 'widgets/player_avatar.dart';
import 'widgets/player_cards.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final size = MediaQuery.of(context).size;
    final players = controller.playerPositions(size);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
            () => Stack(
          children: [
            const PokerTable(),

            Positioned(
              top: size.height * 0.04,
              left: size.width / 2 - 26,
              child: const DealerBadge(),
            ),

            for (var i = 0; i < players.length; i++)
              PlayerAvatar(
                index: i,
                position: players[i],
                zoomAnimation: controller.zoomAnimation,
              ),

            const PlayerCards(),

            if (controller.showCountdown.value)
              Center(
                child: Text(
                  '${controller.countdown.value}',
                  style: TextStyle(
                    fontSize: min(size.width * 0.12, 120),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
