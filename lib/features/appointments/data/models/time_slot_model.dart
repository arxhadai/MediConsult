import '../../domain/entities/time_slot.dart';

/// Data model for TimeSlot entity with JSON serialization
class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.id,
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    super.doctorId,
  });

  /// Create TimeSlotModel from JSON map
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool,
      doctorId: json['doctorId'] as String?,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
      'doctorId': doctorId,
    };
  }

  /// Create TimeSlotModel from TimeSlot entity
  factory TimeSlotModel.fromEntity(TimeSlot timeSlot) {
    return TimeSlotModel(
      id: timeSlot.id,
      startTime: timeSlot.startTime,
      endTime: timeSlot.endTime,
      isAvailable: timeSlot.isAvailable,
      doctorId: timeSlot.doctorId,
    );
  }

  /// Convert to TimeSlot entity
  TimeSlot toEntity() {
    return TimeSlot(
      id: id,
      startTime: startTime,
      endTime: endTime,
      isAvailable: isAvailable,
      doctorId: doctorId,
    );
  }

  /// Create copy with updated fields
  @override
  TimeSlotModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? doctorId,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      doctorId: doctorId ?? this.doctorId,
    );
  }
}
