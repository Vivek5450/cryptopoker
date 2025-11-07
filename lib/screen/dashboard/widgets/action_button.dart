import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final Color borderColor;
  final String? amount;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.borderColor,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, // ✅ consistent button width
        height: 30, // ✅ fixed height for uniformity
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textColor,
              ),
            ),
            // 👇 Reserve space for amount (even if null)
            if ((amount ?? '').isNotEmpty) // ✅ Safe check without !
              Text(
                amount!,
                style: const TextStyle(color: Colors.white,fontSize: 9,height: 1),

              ),
          ],
        ),
      ),
    );
  }
}
