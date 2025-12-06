import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final String statusText;
  
  const ConnectionStatusIndicator({
    super.key,
    this.isConnected = false,
    this.statusText = 'Disconnected',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}