import 'package:flutter/material.dart';

class RefillBadge extends StatelessWidget {
  final int remainingRefills;
  final int totalRefills;

  const RefillBadge({
    super.key,
    required this.remainingRefills,
    required this.totalRefills,
  });

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = remainingRefills > 0 ? Colors.blue : Colors.red;
    final String text = '$remainingRefills/$totalRefills refills';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}