import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/time_slot.dart';

/// Widget for picking available time slots for appointments
class TimeSlotPicker extends StatefulWidget {
  final List<TimeSlot> timeSlots;
  final TimeSlot? selectedTimeSlot;
  final Function(TimeSlot) onTimeSlotSelected;

  const TimeSlotPicker({
    super.key,
    required this.timeSlots,
    this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  TimeSlot? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _selectedTimeSlot = widget.selectedTimeSlot;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.timeSlots.isEmpty)
          const Center(
            child: Text(
              'No available time slots for this date',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
        else
          _buildTimeSlotGrid(),
      ],
    );
  }

  Widget _buildTimeSlotGrid() {
    final availableSlots = widget.timeSlots
        .where((slot) => slot.isAvailable)
        .toList();

    if (availableSlots.isEmpty) {
      return const Center(
        child: Text(
          'No available time slots for this date',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableSlots.map((slot) {
        final isSelected = _selectedTimeSlot?.id == slot.id;
        
        return ChoiceChip(
          label: Text(
            DateFormat('h:mm a').format(slot.startTime),
            style: TextStyle(
              color: isSelected ? Colors.white : null,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedTimeSlot = selected ? slot : null;
            });
            
            if (selected) {
              widget.onTimeSlotSelected(slot);
            }
          },
          selectedColor: Theme.of(context).primaryColor,
          disabledColor: Colors.grey[300],
          labelStyle: TextStyle(
            color: slot.isAvailable ? null : Colors.grey[500],
          ),
        );
      }).toList(),
    );
  }
}