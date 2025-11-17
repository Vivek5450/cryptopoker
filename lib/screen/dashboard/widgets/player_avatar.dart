import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PlayerAvatar extends StatelessWidget {
  final int index;
  final Offset position;
  final Animation<double> zoomAnimation;

  const PlayerAvatar({
    super.key,
    required this.index,
    required this.position,
    required this.zoomAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final isActive = controller.activePlayerIndex.value == index;
      final isTimerActive = controller.timerActive.value;
      final isFolded = controller.playerFolded[index];

      return Positioned(
        left: position.dx - 34,
        top: position.dy - 34,
        child: Opacity(
          opacity: isFolded ? 0.5 : 1.0,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset('assets/images/name_cash_bar.png', height: 40),

            if (isActive && isTimerActive && !isFolded)
                Positioned(
                  left: 0,
                  child: ScaleTransition(
                    scale: zoomAnimation,
                    child: Container(
                      height: 48,
                      width: 47,
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
              Image.asset('assets/images/male_profile.png', height: 47),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WickShar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    const Text(
                      '\$566.32',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
