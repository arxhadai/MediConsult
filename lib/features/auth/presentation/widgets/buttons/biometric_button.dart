import 'package:flutter/material.dart';

/// Button for biometric authentication
class BiometricButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final BiometricType type;

  const BiometricButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.type = BiometricType.fingerprint,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                _icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            const SizedBox(height: 8),
            Text(
              _label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (type) {
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.face:
        return Icons.face;
    }
  }

  String get _label {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Touch ID';
      case BiometricType.face:
        return 'Face ID';
    }
  }
}

/// Biometric authentication types
enum BiometricType {
  fingerprint,
  face,
}
