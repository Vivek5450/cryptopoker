import 'dart:math';
import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PokerTable extends StatelessWidget {
  const PokerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    final players = controller.playerPositions(size);

    return Obx(() {
      final activeIndex = controller.activePlayerIndex.value;
      final betT = controller.betChipProgress.value;
      final chipsFlying = controller.isChipAnimating.value;
      return SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/table.png', fit: BoxFit.cover),
            ),
            // 🟢 Initial Chip Collection Animation
            if (controller.chipsLaid.value)
              ...List.generate(players.length, (i) {
                final begin = players[i];
                final end = center;
                final t = Curves.easeInOutBack.transform(
                  controller.chipProgress.value,
                );
                final pos = Offset(
                  begin.dx + (end.dx - begin.dx) * t,
                  begin.dy + (end.dy - begin.dy) * t,
                );
                return Positioned(
                  left: pos.dx - 18,
                  top: pos.dy - 18,
                  child: Image.asset(
                    'assets/images/chips.png',
                    width: min(size.width * 0.045, 52),
                  ),
                );
              }),

            // 🟡 Bet Animation (player → pot)
            if (chipsFlying)
              Builder(
                builder: (_) {
                  final start = players[activeIndex];
                  final end = center;
                  final t = Curves.easeInOut.transform(betT);
                  final pos = Offset(
                    start.dx + (end.dx - start.dx) * t,
                    start.dy + (end.dy - start.dy) * t,
                  );
                  return Positioned(
                    left: pos.dx - 20,
                    top: pos.dy - 20,
                    child: Image.asset(
                      'assets/images/chips.png',
                      width: min(size.width * 0.06, 56),
                    ),
                  );
                },
              ),
            // 🃏 Community Cards (Flop, Turn, River)

            // Position community cards in the center of the poker table
            // 🃏 Community Cards (Flop, Turn, River)
            Positioned(
              top: size.height * 0.28,
              left: size.width * 0.6 - (controller.communityCards.length * 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    controller.communityCards.map((card) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Image.asset(
                          card, // ← RANDOM CARD HERE
                          width: 55,
                        ),
                      );
                    }).toList(),
              ),
            ),

            /* // 💰 Pot display after chips are in
              if (controller.potShown.value)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/chips.png',
                            width: min(size.width * 0.09, 110),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '\$${controller.potValue.value.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: 'Lobster',
                              fontSize: min(size.width * 0.03, 28),
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),*/
          ],
        ),
      );
    });
  }
}
