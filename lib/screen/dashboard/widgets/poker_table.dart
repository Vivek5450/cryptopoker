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

    return Obx(() => Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/table.png', fit: BoxFit.cover),
        ),
        if (controller.chipsLaid.value)
          ...List.generate(players.length, (i) {
            final begin = players[i];
            final end = center;
            final t = Curves.easeInOutBack.transform(controller.chipProgress.value);
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
        if (controller.potShown.value)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/img_3.png',
                        width: min(size.width * 0.09, 110)),
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
                const SizedBox(height: 5),
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
          ),
      ],
    ));
  }
}
