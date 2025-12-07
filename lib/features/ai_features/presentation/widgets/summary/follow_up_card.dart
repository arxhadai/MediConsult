import 'package:flutter/material.dart';

/// Widget to display follow-up instructions
class FollowUpCard extends StatelessWidget {
  final List<String> instructions;

  const FollowUpCard({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    if (instructions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_note, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Follow-up Instructions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...instructions.map((instruction) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(instruction)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}