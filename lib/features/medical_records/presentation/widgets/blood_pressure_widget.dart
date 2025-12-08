import 'package:flutter/material.dart';

class BloodPressureWidget extends StatelessWidget {
  final double systolic;
  final double diastolic;
  final String? category;

  const BloodPressureWidget({
    super.key,
    required this.systolic,
    required this.diastolic,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;

    if (category != null) {
      switch (category) {
        case 'Normal':
          color = Colors.green;
          break;
        case 'Elevated':
          color = Colors.orange;
          break;
        case 'High (Stage 1)':
        case 'High (Stage 2)':
          color = Colors.red;
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.1),
      ),
      child: Column(
        children: [
          const Text(
            'Blood Pressure',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${systolic.toInt()}/${diastolic.toInt()} mmHg',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (category != null)
            Text(
              category!,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
