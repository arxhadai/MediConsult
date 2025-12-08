import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/vital_signs.dart';

class VitalSignsCard extends StatelessWidget {
  final VitalSigns vitalSigns;

  const VitalSignsCard({super.key, required this.vitalSigns});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(vitalSigns.recordedAt),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  DateFormat('HH:mm').format(vitalSigns.recordedAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Vital signs grid
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              children: [
                if (vitalSigns.bloodPressureFormatted != null)
                  _buildVitalSignItem(
                    context,
                    'Blood Pressure',
                    vitalSigns.bloodPressureFormatted!,
                    vitalSigns.bloodPressureCategory,
                  ),
                if (vitalSigns.heartRate != null)
                  _buildVitalSignItem(
                    context,
                    'Heart Rate',
                    '${vitalSigns.heartRate!.toInt()} bpm',
                  ),
                if (vitalSigns.temperature != null)
                  _buildVitalSignItem(
                    context,
                    'Temperature',
                    '${vitalSigns.temperature!}°F',
                  ),
                if (vitalSigns.weight != null)
                  _buildVitalSignItem(
                    context,
                    'Weight',
                    '${vitalSigns.weight!} kg',
                  ),
                if (vitalSigns.height != null)
                  _buildVitalSignItem(
                    context,
                    'Height',
                    '${vitalSigns.height!} cm',
                  ),
                if (vitalSigns.bloodSugar != null)
                  _buildVitalSignItem(
                    context,
                    'Blood Sugar',
                    '${vitalSigns.bloodSugar!} mg/dL',
                  ),
                if (vitalSigns.oxygenSaturation != null)
                  _buildVitalSignItem(
                    context,
                    'Oxygen Saturation',
                    '${vitalSigns.oxygenSaturation!}%',
                  ),
                if (vitalSigns.respiratoryRate != null)
                  _buildVitalSignItem(
                    context,
                    'Respiratory Rate',
                    '${vitalSigns.respiratoryRate!.toInt()} rpm',
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // BMI if available
            if (vitalSigns.bmi != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BMI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${vitalSigns.bmi!.toStringAsFixed(1)} (${vitalSigns.bmiCategory})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignItem(
    BuildContext context,
    String label,
    String value, [
    String? category,
  ]) {
    Color? color;

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (category != null)
            Text(
              category,
              style: TextStyle(
                fontSize: 10,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
