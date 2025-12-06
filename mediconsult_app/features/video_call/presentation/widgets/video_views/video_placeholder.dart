import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class VideoPlaceholder extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  
  const VideoPlaceholder({
    Key? key,
    this.title = 'No Video',
    this.icon = Icons.videocam_off,
    this.iconColor,
    this.iconSize = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VideoCallColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white30,
              size: iconSize,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}