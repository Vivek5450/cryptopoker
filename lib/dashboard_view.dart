import 'dart:math';
import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    final cardWidth = min(size.width * 0.04, 64).toDouble();
    final players = controller.playerPositions(size);
    final cards = controller.cardPositions(size);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 🎯 Poker table background
            Positioned.fill(
              child: Image.asset('assets/images/table.png', fit: BoxFit.cover),
            ),

            // 🟡 Dealer badge
            Positioned(
              top: size.height * 0.04,
              left: size.width / 2 - 26,
              child: _dealer(),
            ),

            // 🧍 Player Avatars
            for (var i = 0; i < players.length; i++)
              Positioned(
                left: players[i].dx - 34,
                top: players[i].dy - 34,
                child: Obx(() {
                  final isActive = controller.activePlayerIndex.value == i;
                  final isTimerActive = controller.timerActive.value;

                  return playerAvatar(
                    name: "WickShar",
                    balance: 566.32,
                    showActiveGlow: isActive && isTimerActive,
                    zoomAnimation: controller.zoomAnimation,
                  );
                }),
              ),

            // ⏳ Countdown timer
            if (controller.showCountdown.value)
              Center(
                child: Text(
                  '${controller.countdown.value}',
                  style: TextStyle(
                    fontSize: min(size.width * 0.12, 120),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
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
                    'assets/images/img_3.png',
                    width: min(size.width * 0.045, 52),
                  ),
                );
              }),
            // 💰 Pot shown
            if (controller.potShown.value)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/img_3.png',
                          width: min(size.width * 0.09, 110),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '\$120',
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: min(size.width * 0.03, 28),
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20,),
                        Text(
                          'Current Pot Value',
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: min(size.width * 0.03, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // ♠️ All Card logic commented (dealing, revealing, folding)
            if (controller.cardsDealt.value)
              ...List.generate(cards.length, (i) {
                if (i == 4 &&
                    (controller.player5Revealed.value ||
                        controller.player5Packed.value)) {
                  return const SizedBox();
                }

                final target = cards[i];
                final start = Offset(size.width / 2, size.height * 0.08 + 20);
                final t = Curves.easeOutBack.transform(
                  controller.dealProgress.value,
                );
                final pos1 = Offset(
                  start.dx + (target.dx - start.dx) * t,
                  start.dy + (target.dy - start.dy) * t,
                );
                final pos2 = Offset(pos1.dx + cardWidth * 0.6, pos1.dy);

                return Stack(
                  children: [
                    Positioned(
                      left: pos1.dx,
                      top: pos1.dy,
                      child: Image.asset(
                        'assets/images/Card backward.png',
                        width: cardWidth,
                      ),
                    ),
                    Positioned(
                      left: pos2.dx,
                      top: pos2.dy,
                      child: Image.asset(
                        'assets/images/Card backward.png',
                        width: cardWidth,
                      ),
                    ),
                  ],
                );
              }),

            if (controller.cardsDealt.value &&
                !controller.player5Revealed.value &&
                !controller.player5Packed.value)
              Positioned(
                left: cards[4].dx + cardWidth / 2 + 50,
                top: cards[4].dy + 80,
                child: GestureDetector(
                  onTap: controller.revealPlayer5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "See",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🧍 Player avatar UI
  Widget playerAvatar({
    required String name,
    required double balance,
    bool showActiveGlow = false,
    required Animation<double> zoomAnimation,
  }) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background bar
        Image.asset('assets/images/Name & cash bar.png', height: 55),

        // 👇 Active glow (below avatar)
        if (showActiveGlow)
          Positioned(
            left: 0,
            child: ScaleTransition(
              scale: zoomAnimation,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.greenAccent, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // 🧍 Profile image (above glow)
        Image.asset(
          'assets/images/Male profile.png',
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        ),

        // 💬 Name + balance
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '\$ ${balance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🟡 Dealer indicator
  Widget _dealer() => CircleAvatar(
    radius: 26,
    backgroundColor: Colors.yellow[700],
    child: const Text(
      'D',
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'lobster',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}
