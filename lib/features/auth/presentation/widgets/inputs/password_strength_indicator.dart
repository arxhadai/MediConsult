import 'package:flutter/material.dart';
import '../../bloc/registration/registration_state.dart';

/// Visual indicator for password strength
class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildBar(0)),
            const SizedBox(width: 4),
            Expanded(child: _buildBar(1)),
            const SizedBox(width: 4),
            Expanded(child: _buildBar(2)),
            const SizedBox(width: 4),
            Expanded(child: _buildBar(3)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _strengthLabel,
          style: TextStyle(
            fontSize: 12,
            color: _strengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(int index) {
    final isActive = index <= strength.index;
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? _strengthColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Color get _strengthColor {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.good:
        return Colors.yellow[700]!;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String get _strengthLabel {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
}
