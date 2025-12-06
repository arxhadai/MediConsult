import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/video_call_colors.dart';
import '../bloc/video_call_bloc.dart';
import '../widgets/video_views/remote_video_view.dart';
import '../widgets/video_views/local_video_view.dart';
import '../widgets/controls/call_controls_bar.dart';
import '../widgets/indicators/call_timer_widget.dart';
import '../widgets/indicators/network_quality_indicator.dart';
import '../widgets/overlays/waiting_overlay.dart';
import '../widgets/dialogs/end_call_confirmation_dialog.dart';

class VideoCallPage extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  
  const VideoCallPage({
    Key? key,
    required this.doctorName,
    required this.doctorSpecialty,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _isDraggingLocalVideo = false;
  Offset _localVideoPosition = const Offset(16, 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VideoCallColors.background,
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          // Handle state changes
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Remote video view (full screen)
              _buildRemoteVideoView(state),
              
              // Local video view (draggable PIP)
              _buildLocalVideoView(state),
              
              // Top bar with timer and network indicator
              _buildTopBar(state),
              
              // Bottom controls bar
              _buildBottomControls(state),
              
              // Overlays based on state
              _buildOverlays(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRemoteVideoView(VideoCallState state) {
    return const Positioned.fill(
      child: RemoteVideoView(
        participantName: 'Dr. Sarah Johnson',
        isConnected: true,
      ),
    );
  }

  Widget _buildLocalVideoView(VideoCallState state) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      top: _localVideoPosition.dy,
      right: _localVideoPosition.dx,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDraggingLocalVideo = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _localVideoPosition = Offset(
              _localVideoPosition.dx - details.delta.dx,
              _localVideoPosition.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDraggingLocalVideo = false;
          });
        },
        child: const SizedBox(
          width: 120,
          height: 160,
          child: LocalVideoView(),
        ),
      ),
    );
  }

  Widget _buildTopBar(VideoCallState state) {
    return const Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CallTimerWidget(
            duration: Duration(minutes: 5, seconds: 32),
          ),
          NetworkQualityIndicator(
            qualityLevel: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(VideoCallState state) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: CallControlsBar(
        isAudioMuted: false,
        isVideoMuted: false,
        onToggleAudio: () {
          // Toggle audio
          context.read<VideoCallBloc>().add(const VideoCallAudioToggled());
        },
        onToggleVideo: () {
          // Toggle video
          context.read<VideoCallBloc>().add(const VideoCallVideoToggled());
        },
        onSwitchCamera: () {
          // Switch camera
          context.read<VideoCallBloc>().add(const VideoCallCameraSwitched());
        },
        onOpenChat: () {
          // Open chat
        },
        onEndCall: () async {
          // Show confirmation dialog
          final shouldEndCall = await showDialog<bool>(
            context: context,
            builder: (context) => const EndCallConfirmationDialog(),
          );
          
          if (shouldEndCall == true) {
            // End call
            context.read<VideoCallBloc>().add(const VideoCallEndRequested());
            // Navigate back
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }

  Widget _buildOverlays(VideoCallState state) {
    if (state is VideoCallLoading) {
      return const Positioned.fill(
        child: WaitingOverlay(
          message: 'Connecting...',
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
}