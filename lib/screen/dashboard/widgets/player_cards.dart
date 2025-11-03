
import 'dart:math';
import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'action_button.dart';

class PlayerCards extends StatelessWidget {
  const PlayerCards({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final size = MediaQuery.of(context).size;
    final cards = controller.cardPositions(size);
    final cardWidth = min(size.width * 0.04, 64).toDouble();

    return Obx(() {
      if (!controller.cardsDealt.value) return const SizedBox.shrink();

      return Stack(
        children: [
          // ♠️ Card dealing animation
          ...List.generate(cards.length, (i) {
            if (controller.playerPacked[i]) return const SizedBox();

            final target = cards[i];
            final start = Offset(size.width / 2, size.height * 0.08 + 20);
            final t = Curves.easeOutBack.transform(controller.dealProgress.value);
            final pos1 = Offset(
              start.dx + (target.dx - start.dx) * t,
              start.dy + (target.dy - start.dy) * t,
            );
            final pos2 = Offset(pos1.dx + cardWidth * 0.6, pos1.dy);

            bool showFront = i == 4 && controller.player5Revealed.value;

            return Stack(
              children: [
                Positioned(
                  left: pos1.dx,
                  top: pos1.dy,
                  child: Image.asset(
                    showFront
                        ? 'assets/images/spades/img.png'
                        : 'assets/images/Card backward.png',
                    width: cardWidth,
                  ),
                ),
                Positioned(
                  left: pos2.dx,
                  top: pos2.dy,
                  child: Image.asset(
                    showFront
                        ? 'assets/images/spades/img.png'
                        : 'assets/images/Card backward.png',
                    width: cardWidth,
                  ),
                ),
              ],
            );
          }),

          // 🎯 See / Fold button (for Player 5 only)
          if (!controller.playerFolded[4] && !controller.playerPacked[4])
            Positioned(
              left: cards[4].dx + cardWidth / 2 + 50,
              top: cards[4].dy + 80,
              child: controller.player5Revealed.value
                  ? ActionButton(
                label: "Fold",
                color: Colors.redAccent,
                textColor: Colors.white,
                onTap: controller.packPlayer5,
              )
                  : ActionButton(
                label: "See",
                color: Colors.white,
                textColor: Colors.black,
                onTap: controller.revealPlayer5,
              ),
            ),
        ],
      );
    });
  }
}
