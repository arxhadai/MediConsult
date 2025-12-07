import 'package:flutter/material.dart';
import '../../../domain/entities/transcription_segment.dart';

/// Widget to display a transcription segment
class TranscriptText extends StatelessWidget {
  final TranscriptionSegment segment;

  const TranscriptText({
    super.key,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                segment.speakerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${segment.startTime.hour}:${segment.startTime.minute.toString().padLeft(2, '0')}:${segment.startTime.second.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const Spacer(),
              Text(
                '${(segment.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: segment.confidence > 0.8 
                      ? Colors.green 
                      : segment.confidence > 0.5 
                          ? Colors.orange 
                          : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(segment.text),
        ],
      ),
    );
  }
}