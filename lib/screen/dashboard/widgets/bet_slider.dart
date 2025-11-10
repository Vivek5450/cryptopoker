import 'package:cryptopoker/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BetSliderWidget extends StatefulWidget {


  const BetSliderWidget({super.key});

  @override
  State<BetSliderWidget> createState() => _BetSliderWidgetState();
}

class _BetSliderWidgetState extends State<BetSliderWidget> {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Percentage Buttons ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var percent in [0.25, 0.5, 0.75])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: OutlinedButton(
                  onPressed: () => controller.setPercentage(percent),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00BFFF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: Text(
                    '${(percent * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            OutlinedButton(
              onPressed: () => controller.setPercentage(1.0),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00BFFF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              child: const Text('Max', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // --- Slider Row with Buttons ---
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minus Button
            _circleButton('-', controller.decrease),

            // Slider
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.black54,
                  thumbColor: Colors.blue,
                  overlayColor: Colors.transparent,
                  trackHeight: 6,
                ),
                child: Slider(
                  min: controller.min,
                  max: controller.max,
                  divisions:
                  ((controller.max - controller.min) / controller.step)
                      .round(),
                  value: controller.sliderValue.value,
                  onChanged: (v) => controller.sliderValue.value = v,
                ),
              ),
            ),

            // Plus Button
            _circleButton('+', controller.increase),

            // Value Box
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${controller.sliderValue.value.toStringAsFixed(1)}\$',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _circleButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3A3A3A),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
