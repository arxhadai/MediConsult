import 'package:flutter/material.dart';
import 'video_placeholder.dart';

class AgoraVideoView extends StatelessWidget {
  final bool isLocal;
  final int? remoteUid;
  final String? participantName;
  final bool isConnected;
  final bool showPlaceholder;

  const AgoraVideoView({
    super.key,
    this.isLocal = false,
    this.remoteUid,
    this.participantName,
    this.isConnected = false,
    this.showPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    // If explicitly showing placeholder
    if (showPlaceholder) {
      if (isLocal) {
        return const VideoPlaceholder(
          title: 'Local Preview',
          icon: Icons.videocam,
        );
      } else {
        return VideoPlaceholder(
          title: participantName ?? 'Remote Participant',
          icon: Icons.person,
        );
      }
    }

    // Show video container when connected
    if (isConnected) {
      return _buildVideoContainer(
        child: Text(
            isLocal ? 'Local Video' : participantName ?? 'Remote Participant'),
        borderColor: isLocal ? Colors.blue : Colors.green,
      );
    }

    // Show placeholder when not connected
    if (isLocal) {
      return const VideoPlaceholder(
        title: 'Local Preview',
        icon: Icons.videocam,
      );
    } else {
      return VideoPlaceholder(
        title: participantName ?? 'Remote Participant',
        icon: Icons.person,
      );
    }
  }

  Widget _buildVideoContainer({
    required Widget child,
    Color borderColor = Colors.transparent,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video stream would go here in a real implementation
            Container(
              color: Colors.black26,
              child: Center(child: child),
            ),
          ],
        ),
      ),
    );
  }
}
