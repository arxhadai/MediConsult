import '../../domain/entities/appointment.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';

/// Data model for Appointment entity with JSON serialization
class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.patientId,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialty,
    required super.scheduledAt,
    required super.durationMinutes,
    required super.status,
    required super.type,
    super.notes,
    required super.createdAt,
    super.updatedAt,
    super.meetingLink,
    super.roomId,
  });

  /// Create AppointmentModel from JSON map
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationMinutes: json['durationMinutes'] as int,
      status: AppointmentStatus.fromString(json['status'] as String? ?? 'pending'),
      type: ConsultationType.fromString(json['type'] as String? ?? 'video'),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      meetingLink: json['meetingLink'] as String?,
      roomId: json['roomId'] as String?,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'scheduledAt': scheduledAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.value,
      'type': type.value,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'meetingLink': meetingLink,
      'roomId': roomId,
    };
  }

  /// Create AppointmentModel from Appointment entity
  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      doctorName: appointment.doctorName,
      doctorSpecialty: appointment.doctorSpecialty,
      scheduledAt: appointment.scheduledAt,
      durationMinutes: appointment.durationMinutes,
      status: appointment.status,
      type: appointment.type,
      notes: appointment.notes,
      createdAt: appointment.createdAt,
      updatedAt: appointment.updatedAt,
      meetingLink: appointment.meetingLink,
      roomId: appointment.roomId,
    );
  }

  /// Convert to Appointment entity
  Appointment toEntity() {
    return Appointment(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      status: status,
      type: type,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      meetingLink: meetingLink,
      roomId: roomId,
    );
  }

  /// Create copy with updated fields
  @override
  AppointmentModel copyWith({
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
    return AppointmentModel(
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
}
