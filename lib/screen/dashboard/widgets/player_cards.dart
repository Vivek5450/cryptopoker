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

            bool showFront = (i == 4);

            return Stack(
              children: [
                Positioned(
                  left: pos1.dx,
                  top: pos1.dy,
                  child: Image.asset(
                    showFront
                        ? 'assets/images/spades/Q_face.png'
                        : 'assets/images/card_backward.png',
                    width: cardWidth,
                  ),
                ),
                Positioned(
                  left: pos2.dx,
                  top: pos2.dy,
                  child: Image.asset(
                    showFront
                        ? 'assets/images/spades/Q_face.png'
                        : 'assets/images/card_backward.png',
                    width: cardWidth,
                  ),
                ),
              ],
            );
          }),

      if (controller.activePlayerIndex.value == 4 && !controller.playerFolded[4] && !controller.playerPacked[4])
          Positioned(
            // Place buttons relative to player 4 card position
            right: size.width * 0.03, // distance from right edge
            bottom: size.height * 0.02,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionButton(
                  label: "Fold",
                  color: Color.fromARGB(255,69, 40, 40),
                  textColor: Colors.white,
                  onTap: controller.packPlayer5,
                  borderColor: Color.fromARGB(255, 255, 88, 88),
                ),
                SizedBox(width: size.width * 0.01),
                ActionButton(
                  label: "Check",
                  color: Color.fromARGB(255, 44, 69, 40),
                  textColor: Colors.white,
                  onTap: () => controller.check(4),
                  borderColor: Color.fromARGB(255, 88, 255, 127),
                  amount: '\$ 0.5',
                ),
                SizedBox(width: size.width * 0.01),
                ActionButton(
                  label: "Raise",
                  color: Color.fromARGB(255, 40, 69, 69),
                  textColor: Colors.white,
                  onTap: () => controller.bet(4, 100),
                  borderColor: Color.fromARGB(255, 88, 214, 255),
                  amount: '\$0.75',
                ),
                SizedBox(width: size.width * 0.01),

                ActionButton(
                  label: "My Cards",
                  color: Color.fromARGB(255, 69, 51, 40),
                  textColor: Colors.white,
                  onTap: () => controller.bet(4, 100),
                  borderColor: Color.fromARGB(255, 255, 159, 88),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
