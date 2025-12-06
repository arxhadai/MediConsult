import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class EndCallConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  
  const EndCallConfirmationDialog({
    Key? key,
    this.title = 'End Call',
    this.message = 'Are you sure you want to end this call?',
    this.confirmText = 'End Call',
    this.cancelText = 'Cancel',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: VideoCallColors.surface,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: VideoCallColors.endCallRed,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}