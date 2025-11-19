import 'dart:math';
import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'action_button.dart';

class PlayerCards extends StatefulWidget {
  const PlayerCards({super.key});

  @override
  State<PlayerCards> createState() => _PlayerCardsState();
}

class _PlayerCardsState extends State<PlayerCards> {
  final controller = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cards = controller.cardPositions(size);
    final cardWidth = min(size.width * 0.04, 64).toDouble();

    return Obx(() {
      if (!controller.cardsDealt.value) return const SizedBox.shrink();

      return Stack(
        children: [
          if (!controller.isSecondServe.value &&
              !controller.secondDealInProgress.value)
            ...List.generate(cards.length, (i) {
              if (controller.playerPacked[i]) return const SizedBox();

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

              bool showFront = (i == 5);

              String cardImage1;
              String cardImage2;

              if (showFront) {
                cardImage1 = controller.card1.value;
                cardImage2 = controller.card2.value;
              } else {
                cardImage1 = 'assets/images/serve_cards/straight.png';
                cardImage2 = 'assets/images/serve_cards/straight.png';
              }

              return Stack(
                children: [
                  Positioned(
                    left: pos1.dx,
                    top: pos1.dy,
                    child: Image.asset(cardImage1, width: cardWidth),
                  ),
                  // if (showFront)
                  //   Positioned(
                  //     left: pos2.dx,
                  //     top: pos2.dy,
                  //     child: Transform.rotate(
                  //       angle: (i != 5 && !showFront) ? 0.15 : 0.0,
                  //       alignment: Alignment.topCenter,
                  //       child: Image.asset(cardImage2, width: cardWidth),
                  //     ),
                  //   ),
                ],
              );
            }),

          if (controller.secondDealInProgress.value ||
              controller.isSecondServe.value)
            ...List.generate(cards.length, (i) {
              if (controller.playerPacked[i]) return const SizedBox();

              final target = cards[i];
              final start = Offset(size.width / 2, size.height * 0.08 + 20);

              final t =
                  controller.secondDealInProgress.value
                      ? Curves.easeOutBack.transform(
                        controller.secondDealProgress.value,
                      )
                      : 1.0;

              final pos1 = Offset(
                start.dx + (target.dx - start.dx) * t,
                start.dy + (target.dy - start.dy) * t,
              );
              final pos2 = Offset(pos1.dx + cardWidth * 1.1, pos1.dy);

              bool showFront = (i == 5);

              String cardImage1;
              String cardImage2;

              if (showFront) {
                cardImage1 = controller.card1.value;
                cardImage2 = controller.card2.value;
              } else {
                cardImage1 = 'assets/images/serve_cards/combine.png';
                cardImage2 = 'assets/images/serve_cards/combine.png';
              }

              return Stack(
                children: [
                  Positioned(
                    left: pos1.dx,
                    top: pos1.dy,
                    child: Image.asset(
                      cardImage1,
                      width: !showFront ? 48 : cardWidth,
                    ),
                  ),
                  if (showFront)
                    Positioned(
                      left: pos2.dx,
                      top: pos2.dy,
                      child: Transform.rotate(
                        angle: (i != 5 && !showFront) ? 0.15 : 0.0,
                        alignment: Alignment.topCenter,
                        child: Image.asset(cardImage2, width: cardWidth),
                      ),
                    ),
                ],
              );
            }),

          if (controller.activePlayerIndex.value == 5 &&
              !controller.playerFolded[5] &&
              !controller.playerPacked[5])
            Stack(
              children: [
                Positioned(
                  right: size.width * 0.015,
                  bottom: size.height * 0.25,
                  child: Row(children: [betButton('Time (30sec)', 4)]),
                ),
                Positioned(
                  right: size.width * 0.015,
                  bottom: size.height * 0.17,
                  child: Row(
                    children: [
                      betButton('25%', 0),
                      SizedBox(width: size.width * 0.01),
                      betButton('50%', 1),
                      SizedBox(width: size.width * 0.01),
                      betButton('75%', 2),
                      SizedBox(width: size.width * 0.01),
                      betButton('Max', 3),
                    ],
                  ),
                ),
                Positioned(
                  right: size.width * 0.015,
                  bottom: size.height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _circleButton(() {
                        controller.decrease();
                      }, 'assets/images/minus.png'),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          thumbColor: const Color.fromARGB(255, 2, 113, 159),
                          overlayColor: Colors.transparent,
                          activeTickMarkColor: Colors.transparent,
                          inactiveTickMarkColor: Colors.transparent,
                          trackHeight: 15,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 9,
                          ),
                        ),
                        child: SizedBox(
                          width: size.width * 0.3,
                          child: Slider(
                            min: controller.min,
                            max: controller.max,
                            divisions:
                                ((controller.max - controller.min) /
                                        controller.step)
                                    .round(),
                            value: controller.sliderValue.value,
                            onChanged: (v) => controller.sliderValue.value = v,
                          ),
                        ),
                      ),
                      _circleButton(() {
                        controller.increase();
                      }, 'assets/images/plus.png'),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color.fromARGB(255, 48, 50, 57),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 30,
                        ),
                        child: Text(
                          '${controller.sliderValue.value.toInt()}\$',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons Row (same as before)
                Positioned(
                  right: size.width * 0.03,
                  bottom: size.height * 0.01,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionButton(
                        label: "Fold",
                        color: const Color.fromARGB(255, 69, 40, 40),
                        textColor: Colors.white,
                        onTap: controller.packPlayer5,
                        borderColor: const Color.fromARGB(255, 255, 88, 88),
                      ),
                      SizedBox(width: size.width * 0.01),
                      ActionButton(
                        label: "Check",
                        color: const Color.fromARGB(255, 44, 69, 40),
                        textColor: Colors.white,
                        onTap: () => controller.check(4),
                        borderColor: const Color.fromARGB(255, 88, 255, 127),
                        amount: '0.5\$',
                      ),
                      SizedBox(width: size.width * 0.01),
                      ActionButton(
                        label: "Raise",
                        color: const Color.fromARGB(255, 40, 69, 69),
                        textColor: Colors.white,
                        onTap: () => controller.bet(4, 100),
                        borderColor: const Color.fromARGB(255, 88, 214, 255),
                        amount: '0.75\$',
                      ),
                      SizedBox(width: size.width * 0.01),
                      ActionButton(
                        label: "My Cards",
                        color: const Color.fromARGB(255, 69, 51, 40),
                        textColor: Colors.white,
                        onTap: () => controller.bet(4, 100),
                        borderColor: const Color.fromARGB(255, 255, 159, 88),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }

  Widget _circleButton(VoidCallback onTap, String image) {
    return GestureDetector(onTap: onTap, child: Image.asset(image, height: 25));
  }

  Widget betButton(String betAmount, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (controller.selectedIndex.value == index &&
                              controller.selectedIndex.value != 4) ||
                          index == 3
                      ? const Color.fromARGB(255, 88, 214, 255)
                      : Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 23, 24, 26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              betAmount,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }
}
