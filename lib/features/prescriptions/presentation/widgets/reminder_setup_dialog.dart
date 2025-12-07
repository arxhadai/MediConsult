import 'package:flutter/material.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/medication.dart';

class ReminderSetupDialog extends StatefulWidget {
  final Medication medication;

  const ReminderSetupDialog({super.key, required this.medication});

  @override
  State<ReminderSetupDialog> createState() => _ReminderSetupDialogState();
}

class _ReminderSetupDialogState extends State<ReminderSetupDialog> {
  late TimeOfDay _selectedTime;
  bool _repeatDaily = true;
  int _repeatInterval = 1; // Every X days

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Reminder for ${widget.medication.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Time:'),
            const SizedBox(height: 8),
            ListTile(
              title: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            
            const Text('Repeat:'),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Daily'),
              value: _repeatDaily,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _repeatDaily = value;
                  });
                }
              },
            ),
            
            if (!_repeatDaily)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Every X days:'),
                  Slider(
                    value: _repeatInterval.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$_repeatInterval',
                    onChanged: (value) {
                      setState(() {
                        _repeatInterval = value.toInt();
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _setReminder,
          child: const Text('Set Reminder'),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _setReminder() async {
    // TODO: Implement actual notification scheduling
    // This is a placeholder implementation
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder scheduled successfully!'),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}