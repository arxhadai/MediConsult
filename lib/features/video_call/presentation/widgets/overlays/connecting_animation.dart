import 'package:flutter/material.dart';
import '../../../../../core/constants/video_call_colors.dart';

class ConnectingAnimation extends StatefulWidget {
  final String message;
  final bool isConnecting;

  const ConnectingAnimation({
    super.key,
    required this.message,
    this.isConnecting = true,
  });

  @override
  State<ConnectingAnimation> createState() => _ConnectingAnimationState();
}

class _ConnectingAnimationState extends State<ConnectingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isConnecting) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ConnectingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnecting != widget.isConnecting) {
      if (widget.isConnecting) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: VideoCallColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: VideoCallColors.primary,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.videocam,
                  color: VideoCallColors.primary,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.isConnecting)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: VideoCallColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
