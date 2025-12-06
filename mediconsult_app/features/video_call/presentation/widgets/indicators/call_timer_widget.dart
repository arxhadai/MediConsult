import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class CallTimerWidget extends StatelessWidget {
  final Duration duration;
  final bool isRecording;
  
  const CallTimerWidget({
    Key? key,
    required this.duration,
    this.isRecording = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String timeString = _formatDuration(duration);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: VideoCallColors.controlsBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording) ...[
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: VideoCallColors.endCallRed,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Text(
            timeString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}