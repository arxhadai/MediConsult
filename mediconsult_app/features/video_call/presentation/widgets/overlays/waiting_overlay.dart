import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class WaitingOverlay extends StatelessWidget {
  final String message;
  final bool showProgressBar;
  
  const WaitingOverlay({
    Key? key,
    this.message = 'Connecting...',
    this.showProgressBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VideoCallColors.background.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showProgressBar) ...[
              const SizedBox(height: 24),
              const SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  color: VideoCallColors.primary,
                  backgroundColor: VideoCallColors.surface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}