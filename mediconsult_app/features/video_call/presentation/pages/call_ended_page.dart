import 'package:flutter/material.dart';
import '../../../../core/constants/video_call_colors.dart';

class CallEndedPage extends StatelessWidget {
  final String doctorName;
  final Duration callDuration;
  final String? notes;
  
  const CallEndedPage({
    super.key,
    required this.doctorName,
    required this.callDuration,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VideoCallColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Call ended icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: VideoCallColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.call_end,
                  color: VideoCallColors.endCallRed,
                  size: 48,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Call Ended',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Doctor name
              Text(
                'with $doctorName',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Call details
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: VideoCallColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.timer,
                      label: 'Duration',
                      value: _formatDuration(callDuration),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.date_range,
                      label: 'Date',
                      value: _formatDate(DateTime.now()),
                    ),
                    if (notes != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.note,
                        label: 'Notes',
                        value: notes!,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Action buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Return to home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VideoCallColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: VideoCallColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '$minutes min ${seconds}s';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}