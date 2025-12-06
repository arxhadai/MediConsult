import 'package:equatable/equatable.dart';

/// Represents a time slot for booking appointments
class TimeSlot extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? doctorId;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.doctorId,
  });

  /// Duration of the time slot in minutes
  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Check if slot is in the future
  bool get isFuture => startTime.isAfter(DateTime.now());

  /// Check if slot is today
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  /// Get formatted time for display
  String get formattedTime {
    return '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - '
        '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  /// Create a copy with updated fields
  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? doctorId,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      doctorId: doctorId ?? this.doctorId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        isAvailable,
        doctorId,
      ];
}
