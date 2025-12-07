import 'package:equatable/equatable.dart';

/// Base class for all appointment events
abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load upcoming appointments
class AppointmentsLoadRequested extends AppointmentEvent {
  final String patientId;

  const AppointmentsLoadRequested(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to load appointment history
class AppointmentHistoryLoadRequested extends AppointmentEvent {
  final String patientId;

  const AppointmentHistoryLoadRequested(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

/// Event to load doctor appointments
class DoctorAppointmentsLoadRequested extends AppointmentEvent {
  final String doctorId;
  final DateTime? date;

  const DoctorAppointmentsLoadRequested(this.doctorId, [this.date]);

  @override
  List<Object?> get props => [doctorId, date];
}

/// Event to refresh appointments
class AppointmentsRefreshRequested extends AppointmentEvent {
  const AppointmentsRefreshRequested();
}

/// Event to cancel an appointment
class AppointmentCancelRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientId;

  const AppointmentCancelRequested(this.appointmentId, this.patientId);

  @override
  List<Object?> get props => [appointmentId, patientId];
}

/// Event to join waiting room
class WaitingRoomJoinRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientId;

  const WaitingRoomJoinRequested(this.appointmentId, this.patientId);

  @override
  List<Object?> get props => [appointmentId, patientId];
}

/// Event to leave waiting room
class WaitingRoomLeaveRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientId;

  const WaitingRoomLeaveRequested(this.appointmentId, this.patientId);

  @override
  List<Object?> get props => [appointmentId, patientId];
}

/// Event to get waiting room position
class WaitingRoomPositionRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientId;

  const WaitingRoomPositionRequested(this.appointmentId, this.patientId);

  @override
  List<Object?> get props => [appointmentId, patientId];
}