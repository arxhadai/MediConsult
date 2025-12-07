import 'package:equatable/equatable.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/enums/consultation_type.dart';

/// Base class for all booking events
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to search for doctors
class DoctorSearchRequested extends BookingEvent {
  final String? specialty;
  final String? name;

  const DoctorSearchRequested({this.specialty, this.name});

  @override
  List<Object?> get props => [specialty, name];
}

/// Event to load doctor schedule
class DoctorScheduleLoadRequested extends BookingEvent {
  final String doctorId;

  const DoctorScheduleLoadRequested(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

/// Event to load available time slots
class TimeSlotsLoadRequested extends BookingEvent {
  final String doctorId;
  final DateTime date;

  const TimeSlotsLoadRequested(this.doctorId, this.date);

  @override
  List<Object?> get props => [doctorId, date];
}

/// Event to select a time slot
class TimeSlotSelected extends BookingEvent {
  final TimeSlot timeSlot;

  const TimeSlotSelected(this.timeSlot);

  @override
  List<Object?> get props => [timeSlot];
}

/// Event to book an appointment
class AppointmentBookingRequested extends BookingEvent {
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final ConsultationType type;
  final String? notes;

  const AppointmentBookingRequested({
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.type,
    this.notes,
  });

  @override
  List<Object?> get props => [
        patientId,
        doctorId,
        scheduledAt,
        durationMinutes,
        type,
        notes,
      ];
}

/// Event to clear booking state
class BookingClearRequested extends BookingEvent {
  const BookingClearRequested();
}