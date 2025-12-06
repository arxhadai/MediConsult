import 'package:flutter/material.dart';

/// Widget to display a list of medications
class MedicationList extends StatelessWidget {
  final List<String> medications;

  const MedicationList({
    super.key,
    required this.medications,
  });

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) {
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
                const Icon(Icons.medication, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Medications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...medications.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(med)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}