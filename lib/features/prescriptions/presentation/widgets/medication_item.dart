import 'package:flutter/material.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/medication.dart';

class MedicationItem extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onDelete;

  const MedicationItem({super.key, required this.medication, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication name and form
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    medication.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
            ),

            // Brand name if available
            if (medication.brandName != null)
              Text(
                medication.brandName!,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

            const SizedBox(height: 8),

            // Dosage and frequency
            Text(
              '${medication.dosage} ${medication.formDisplayText}',
              style: const TextStyle(fontSize: 14),
            ),

            Text(
              medication.frequencyDisplayText,
              style: const TextStyle(fontSize: 14),
            ),

            // Timing if specified
            if (medication.timings.isNotEmpty)
              Text(
                medication.timingDisplayText,
                style: const TextStyle(fontSize: 14),
              ),

            const SizedBox(height: 8),

            // Duration and quantity
            Row(
              children: [
                Text(
                  'Duration: ${medication.durationDays} days',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Text(
                  'Quantity: ${medication.quantity}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            // Instructions if available
            if (medication.instructions != null &&
                medication.instructions!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Instructions: ${medication.instructions}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

            // Warnings if available
            if (medication.warnings != null && medication.warnings!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Warnings: ${medication.warnings}',
                    style: const TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
