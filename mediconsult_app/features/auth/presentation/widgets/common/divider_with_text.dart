import 'package:flutter/material.dart';

/// Divider with centered text
class DividerWithText extends StatelessWidget {
  final String text;
  final Color? color;

  const DividerWithText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? Colors.grey[300];

    return Row(
      children: [
        Expanded(
          child: Divider(color: dividerColor, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: dividerColor, thickness: 1),
        ),
      ],
    );
  }
}
