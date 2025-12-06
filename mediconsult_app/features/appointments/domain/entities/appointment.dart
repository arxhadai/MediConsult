import 'package:equatable/equatable.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';

/// Represents an appointment in the MediConsult system
class Appointment extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime scheduledAt;
  final int durationMinutes;
  final AppointmentStatus status;
  final ConsultationType type;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? meetingLink; // For video consultations
  final String? roomId; // For chat consultations

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    required this.type,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.meetingLink,
    this.roomId,
  });

  /// Check if appointment is upcoming
  bool get isUpcoming => scheduledAt.isAfter(DateTime.now()) && status.isActive;

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }

  /// Check if appointment can be cancelled
  bool get canBeCancelled => status.isActive;

  /// Check if appointment can be rescheduled
  bool get canBeRescheduled => status.isActive;

  /// Get formatted time for display
  String get formattedTime {
    return '${scheduledAt.hour}:${scheduledAt.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted date for display
  String get formattedDate {
    return '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year}';
  }

  /// Create a copy with updated fields
  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    DateTime? scheduledAt,
    int? durationMinutes,
    AppointmentStatus? status,
    ConsultationType? type,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? meetingLink,
    String? roomId,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      meetingLink: meetingLink ?? this.meetingLink,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        doctorName,
        doctorSpecialty,
        scheduledAt,
        durationMinutes,
        status,
        type,
        notes,
        createdAt,
        updatedAt,
        meetingLink,
        roomId,
      ];
}
