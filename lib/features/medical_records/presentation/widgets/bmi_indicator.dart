import 'package:flutter/material.dart';

class BmiIndicator extends StatelessWidget {
  final double bmi;
  final String category;

  const BmiIndicator({
    super.key,
    required this.bmi,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (category) {
      case 'Underweight':
        color = Colors.blue;
        break;
      case 'Normal':
        color = Colors.green;
        break;
      case 'Overweight':
        color = Colors.orange;
        break;
      case 'Obese':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
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
            'BMI',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            category,
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
