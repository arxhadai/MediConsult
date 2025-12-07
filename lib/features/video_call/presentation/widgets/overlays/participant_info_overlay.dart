import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class ParticipantInfoOverlay extends StatelessWidget {
  final String participantName;
  final String specialty;
  final bool isConnected;
  final bool isMuted;
  
  const ParticipantInfoOverlay({
    super.key,
    required this.participantName,
    required this.specialty,
    this.isConnected = false,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VideoCallColors.controlsBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected 
                  ? VideoCallColors.onlineGreen 
                  : VideoCallColors.warningOrange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          
          // Participant info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                participantName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                specialty,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 8),
          
          // Mute indicator
          if (isMuted) ...[
            const Icon(
              Icons.mic_off,
              color: VideoCallColors.warningOrange,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }
}