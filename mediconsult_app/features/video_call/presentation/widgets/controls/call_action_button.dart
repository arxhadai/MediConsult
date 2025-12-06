import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback? onPressed;

  const CallActionButton({
    Key? key,
    required this.icon,
    this.activeIcon,
    required this.label,
    this.isActive = false,
    this.isDestructive = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData displayIcon = isActive && activeIcon != null ? activeIcon! : icon;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDestructive 
                ? VideoCallColors.endCallRed 
                : (isActive 
                    ? VideoCallColors.activeButton 
                    : VideoCallColors.controlsBackground),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              displayIcon,
              color: isDestructive || isActive 
                  ? Colors.white 
                  : VideoCallColors.inactiveButton,
              size: 28,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}