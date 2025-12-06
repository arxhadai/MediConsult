import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget for displaying a calendar for appointment booking
class CalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month header
        _buildMonthHeader(),
        
        const SizedBox(height: 16),
        
        // Weekday headers
        _buildWeekdayHeaders(),
        
        const SizedBox(height: 8),
        
        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousMonth,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextMonth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    
    // Calculate the first day of the week for the first day of the month
    final firstDayOfWeek = firstDayOfMonth.weekday % 7; // 0 = Sunday, 1 = Monday, etc.
    
    // Create a list of days to display
    final days = <Widget>[];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayOfWeek; i++) {
      days.add(const SizedBox.shrink());
    }
    
    // Add cells for each day of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_selectedDate.year, _selectedDate.month, day);
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      
      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            widget.onDateSelected(date);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: Theme.of(context).primaryColor)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? Theme.of(context).primaryColor
                          : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: days,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }
}