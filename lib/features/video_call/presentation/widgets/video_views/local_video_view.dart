import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class LocalVideoView extends StatelessWidget {
  final bool isVisible;
  
  const LocalVideoView({super.key, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: VideoCallColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam,
              color: Colors.white30,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Local Video',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}