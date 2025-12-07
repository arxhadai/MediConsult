import 'package:flutter/material.dart';
import '../../domain/enums/medication_frequency.dart';

class FrequencyPicker extends StatelessWidget {
  final MedicationFrequency initialFrequency;
  final Function(MedicationFrequency) onFrequencyChanged;

  const FrequencyPicker({
    super.key,
    required this.initialFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<MedicationFrequency>(
          initialValue: initialFrequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: MedicationFrequency.values.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text(_getFrequencyDisplayName(frequency)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onFrequencyChanged(value);
            }
          },
        ),
      ],
    );
  }

  String _getFrequencyDisplayName(MedicationFrequency frequency) {
    switch (frequency) {
      case MedicationFrequency.onceDaily:
        return 'Once daily';
      case MedicationFrequency.twiceDaily:
        return 'Twice daily';
      case MedicationFrequency.thriceDaily:
        return 'Three times daily';
      case MedicationFrequency.fourTimesDaily:
        return 'Four times daily';
      case MedicationFrequency.every4Hours:
        return 'Every 4 hours';
      case MedicationFrequency.every6Hours:
        return 'Every 6 hours';
      case MedicationFrequency.every8Hours:
        return 'Every 8 hours';
      case MedicationFrequency.every12Hours:
        return 'Every 12 hours';
      case MedicationFrequency.weekly:
        return 'Once weekly';
      case MedicationFrequency.asNeeded:
        return 'As needed (PRN)';
    }
  }
}
