import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';
import 'call_action_button.dart';

class CallControlsBar extends StatelessWidget {
  final bool isAudioMuted;
  final bool isVideoMuted;
  final bool isFrontCamera;
  final VoidCallback? onToggleAudio;
  final VoidCallback? onToggleVideo;
  final VoidCallback? onSwitchCamera;
  final VoidCallback? onOpenChat;
  final VoidCallback? onEndCall;

  const CallControlsBar({
    Key? key,
    this.isAudioMuted = false,
    this.isVideoMuted = false,
    this.isFrontCamera = true,
    this.onToggleAudio,
    this.onToggleVideo,
    this.onSwitchCamera,
    this.onOpenChat,
    this.onEndCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            VideoCallColors.controlsBackground,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CallActionButton(
              icon: Icons.mic,
              activeIcon: Icons.mic_off,
              label: 'Mute',
              isActive: isAudioMuted,
              onPressed: onToggleAudio,
            ),
            CallActionButton(
              icon: Icons.videocam,
              activeIcon: Icons.videocam_off,
              label: 'Video',
              isActive: isVideoMuted,
              onPressed: onToggleVideo,
            ),
            CallActionButton(
              icon: Icons.cameraswitch,
              label: 'Flip',
              onPressed: onSwitchCamera,
            ),
            CallActionButton(
              icon: Icons.chat,
              label: 'Chat',
              onPressed: onOpenChat,
            ),
            CallActionButton(
              icon: Icons.call_end,
              label: 'End',
              isDestructive: true,
              onPressed: onEndCall,
            ),
          ],
        ),
      ),
    );
  }
}