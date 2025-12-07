import 'package:flutter/material.dart';
import '../../domain/enums/medication_timing.dart';

class TimingSelector extends StatefulWidget {
  final List<MedicationTiming> initialTimings;
  final Function(List<MedicationTiming>) onTimingsChanged;

  const TimingSelector({
    super.key,
    required this.initialTimings,
    required this.onTimingsChanged,
  });

  @override
  State<TimingSelector> createState() => _TimingSelectorState();
}

class _TimingSelectorState extends State<TimingSelector> {
  late List<MedicationTiming> _selectedTimings;

  @override
  void initState() {
    super.initState();
    _selectedTimings = List.from(widget.initialTimings);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Timing (Optional)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MedicationTiming.values.map((timing) {
            final isSelected = _selectedTimings.contains(timing);
            return FilterChip(
              label: Text(_getTimingDisplayName(timing)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTimings.add(timing);
                  } else {
                    _selectedTimings.remove(timing);
                  }
                  widget.onTimingsChanged(List.from(_selectedTimings));
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getTimingDisplayName(MedicationTiming timing) {
    switch (timing) {
      case MedicationTiming.morning:
        return 'Morning';
      case MedicationTiming.afternoon:
        return 'Afternoon';
      case MedicationTiming.evening:
        return 'Evening';
      case MedicationTiming.night:
        return 'Night';
      case MedicationTiming.beforeBreakfast:
        return 'Before Breakfast';
      case MedicationTiming.afterBreakfast:
        return 'After Breakfast';
      case MedicationTiming.beforeLunch:
        return 'Before Lunch';
      case MedicationTiming.afterLunch:
        return 'After Lunch';
      case MedicationTiming.beforeDinner:
        return 'Before Dinner';
      case MedicationTiming.afterDinner:
        return 'After Dinner';
      case MedicationTiming.bedtime:
        return 'Bedtime';
      case MedicationTiming.emptyStomach:
        return 'Empty Stomach';
      case MedicationTiming.withFood:
        return 'With Food';
    }
  }
}