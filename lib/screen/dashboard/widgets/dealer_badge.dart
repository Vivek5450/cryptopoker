import 'package:flutter/material.dart';

class DealerBadge extends StatelessWidget {
  const DealerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
}
