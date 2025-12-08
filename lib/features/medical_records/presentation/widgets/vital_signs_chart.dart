import 'package:flutter/material.dart';
import '../../domain/entities/vital_signs.dart';

class VitalSignsChart extends StatelessWidget {
  final List<VitalSigns> vitalSignsHistory;

  const VitalSignsChart({super.key, required this.vitalSignsHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vital Signs Trend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    // For simplicity, we'll show a sample chart with heart rate trend
    // In a real implementation, you would use the charts_flutter package

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.show_chart,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Vital Signs Chart',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Implementation would use charts_flutter package\n'
            'to display trends for blood pressure, heart rate,\n'
            'weight, and other vital signs over time.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
