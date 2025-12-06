import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class EndCallButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  
  const EndCallButton({
    Key? key,
    this.onPressed,
    this.size = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: VideoCallColors.endCallRed,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.call_end,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onPressed,
      ),
    );
  }
}