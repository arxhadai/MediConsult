import 'package:flutter/material.dart';
import '../../../domain/enums/urgency_level.dart';

/// Widget to display an urgency banner
class UrgencyBanner extends StatelessWidget {
  final UrgencyLevel urgencyLevel;

  const UrgencyBanner({
    Key? key,
    required this.urgencyLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bannerData = _getBannerData(urgencyLevel);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerData.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            bannerData.icon,
            color: bannerData.textColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              bannerData.message,
              style: TextStyle(
                color: bannerData.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon, String message, Color textColor}) _getBannerData(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return (
          color: Colors.green.shade100,
          icon: Icons.info_outline,
          message: 'Low urgency - Routine care recommended',
          textColor: Colors.green.shade800,
        );
      case UrgencyLevel.medium:
        return (
          color: Colors.orange.shade100,
          icon: Icons.warning_amber_outlined,
          message: 'Medium urgency - Care needed soon',
          textColor: Colors.orange.shade800,
        );
      case UrgencyLevel.high:
        return (
          color: Colors.red.shade100,
          icon: Icons.error_outline,
          message: 'High urgency - Seek care immediately',
          textColor: Colors.red.shade800,
        );
      case UrgencyLevel.emergency:
        return (
          color: Colors.red,
          icon: Icons.error,
          message: 'EMERGENCY - Seek immediate medical attention',
          textColor: Colors.white,
        );
    }
  }
}