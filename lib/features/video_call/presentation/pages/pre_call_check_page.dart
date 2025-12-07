import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/video_call_colors.dart';
import '../bloc/video_call_bloc.dart';

class PreCallCheckPage extends StatefulWidget {
  final String consultationId;
  final String doctorName;
  final String doctorSpecialty;
  
  const PreCallCheckPage({
    super.key,
    required this.consultationId,
    required this.doctorName,
    required this.doctorSpecialty,
  });

  @override
  State<PreCallCheckPage> createState() => _PreCallCheckPageState();
}

class _PreCallCheckPageState extends State<PreCallCheckPage> {
  final bool _permissionsGranted = false;
  final bool _cameraReady = true;
  final bool _microphoneReady = true;
  final bool _networkGood = true;

  @override
  void initState() {
    super.initState();
    // Initialize video call service
    context.read<VideoCallBloc>().add(const VideoCallInitializeRequested(
      consultationId: '', // Would come from widget in real implementation
      isVideoCall: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VideoCallColors.background,
      appBar: AppBar(
        backgroundColor: VideoCallColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppConstants.appName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Local video preview
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: VideoCallColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Placeholder for local video view
                    Container(
                      color: VideoCallColors.surface,
                      child: const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white30,
                          size: 48,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: VideoCallColors.controlsBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const IconButton(
                          icon: Icon(
                            Icons.cameraswitch,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Device status indicators
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VideoCallColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatusRow(Icons.videocam, 'Camera', _cameraReady),
                  const SizedBox(height: 12),
                  _buildStatusRow(Icons.mic, 'Microphone', _microphoneReady),
                  const SizedBox(height: 12),
                  _buildStatusRow(Icons.wifi, 'Network', _networkGood),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Doctor info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VideoCallColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.doctorSpecialty,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Consultation #${widget.consultationId}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _permissionsGranted ? () {
                      // Join video call
                      context.read<VideoCallBloc>().add(const VideoCallJoinRequested(
                        token: '', // Would come from backend in real implementation
                        channelName: 'consultation_test',
                        uid: 0, // Would be assigned by backend in real implementation
                        enableVideo: true,
                      ));
                      // Navigate to video call page
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VideoCallColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Join Video Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _permissionsGranted ? () {
                      // Join audio-only call
                      context.read<VideoCallBloc>().add(const VideoCallJoinRequested(
                        token: '', // Would come from backend in real implementation
                        channelName: 'consultation_test',
                        uid: 0, // Would be assigned by backend in real implementation
                        enableVideo: false,
                      ));
                      // Navigate to video call page
                    } : null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Audio Only Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, String label, bool isReady) {
    return Row(
      children: [
        Icon(
          icon,
          color: isReady ? VideoCallColors.onlineGreen : VideoCallColors.warningOrange,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        Icon(
          isReady ? Icons.check_circle : Icons.error,
          color: isReady ? VideoCallColors.onlineGreen : VideoCallColors.warningOrange,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          isReady ? 'Ready' : 'Issue',
          style: TextStyle(
            color: isReady ? VideoCallColors.onlineGreen : VideoCallColors.warningOrange,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}