import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final int initialDurationDays;
  final Function(int) onDurationChanged;

  const DurationPicker({
    super.key,
    required this.initialDurationDays,
    required this.onDurationChanged,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late int _durationDays;

  @override
  void initState() {
    super.initState();
    _durationDays = widget.initialDurationDays;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duration (days) *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (_durationDays > 1) {
                  setState(() {
                    _durationDays--;
                    widget.onDurationChanged(_durationDays);
                  });
                }
              },
            ),
            Expanded(
              child: Slider(
                value: _durationDays.toDouble(),
                min: 1,
                max: 365,
                divisions: 364,
                label: '$_durationDays days',
                onChanged: (value) {
                  setState(() {
                    _durationDays = value.toInt();
                    widget.onDurationChanged(_durationDays);
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (_durationDays < 365) {
                  setState(() {
                    _durationDays++;
                    widget.onDurationChanged(_durationDays);
                  });
                }
              },
            ),
          ],
        ),
        Text(
          '$_durationDays days',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}