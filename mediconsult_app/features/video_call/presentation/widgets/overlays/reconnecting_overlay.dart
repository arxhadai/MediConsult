import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class ReconnectingOverlay extends StatelessWidget {
  final String message;
  final int attemptCount;
  
  const ReconnectingOverlay({
    Key? key,
    this.message = 'Reconnecting...',
    this.attemptCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VideoCallColors.background.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off,
              color: VideoCallColors.warningOrange,
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
            if (attemptCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Attempt $attemptCount',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 24),
            const SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                color: VideoCallColors.warningOrange,
                backgroundColor: VideoCallColors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}