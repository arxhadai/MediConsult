import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class NetworkQualityIndicator extends StatelessWidget {
  final int qualityLevel; // 0-4 bars
  final double size;
  
  const NetworkQualityIndicator({
    super.key,
    this.qualityLevel = 0,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final bool isActive = index < qualityLevel;
        final Color barColor = _getBarColor(index, isActive);
        
        return Container(
          width: size / 4,
          height: size * (0.4 + (index * 0.2)), // Increasing height for each bar
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size / 8)),
          ),
        );
      }),
    );
  }

  Color _getBarColor(int index, bool isActive) {
    if (!isActive) {
      return Colors.grey; // Inactive bars
    }
    
    // Active bars color based on quality level
    switch (qualityLevel) {
      case 4:
        return VideoCallColors.onlineGreen; // Excellent
      case 3:
        return VideoCallColors.onlineGreen.withValues(alpha: 0.8); // Good
      case 2:
        return VideoCallColors.warningOrange; // Poor
      case 1:
        return VideoCallColors.endCallRed; // Bad
      default:
        return Colors.grey; // Unknown
    }
  }
}