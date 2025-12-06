import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class PermissionRequestDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<String> permissions;
  final String confirmText;
  final String cancelText;
  
  const PermissionRequestDialog({
    super.key,
    this.title = 'Permission Required',
    this.message = 'This app needs the following permissions to function properly:',
    this.permissions = const ['Camera', 'Microphone'],
    this.confirmText = 'Allow',
    this.cancelText = 'Deny',
  });

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ...permissions.map((permission) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: VideoCallColors.onlineGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  permission,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
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
            backgroundColor: VideoCallColors.primary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}