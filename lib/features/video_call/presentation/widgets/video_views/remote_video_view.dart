import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class RemoteVideoView extends StatelessWidget {
  final String participantName;
  final bool isConnected;
  final bool isVisible;
  
  const RemoteVideoView({
    super.key,
    required this.participantName,
    this.isConnected = false,
    this.isVisible = true,
  });

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
      child: Stack(
        children: [
          // Video feed placeholder
          Container(
            color: VideoCallColors.background,
            child: const Center(
              child: Icon(
                Icons.videocam,
                color: Colors.white30,
                size: 64,
              ),
            ),
          ),
          
          // Participant info overlay
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: VideoCallColors.controlsBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(
                    participantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}