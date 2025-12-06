import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment.dart';

/// Base class for all appointment states
abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

/// Loading state
class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

/// Loaded state with appointments
class AppointmentsLoaded extends AppointmentState {
  final List<Appointment> appointments;
  final bool isHistory;

  const AppointmentsLoaded({
    required this.appointments,
    this.isHistory = false,
  });

  @override
  List<Object?> get props => [appointments, isHistory];
}

/// Loaded state with doctor appointments
class DoctorAppointmentsLoaded extends AppointmentState {
  final List<Appointment> appointments;
  final String doctorId;

  const DoctorAppointmentsLoaded({
    required this.appointments,
    required this.doctorId,
  });

  @override
  List<Object?> get props => [appointments, doctorId];
}

/// Error state
class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Waiting room state
class WaitingRoomState extends AppointmentState {
  final int position;
  final bool isInWaitingRoom;

  const WaitingRoomState({
    required this.position,
    required this.isInWaitingRoom,
  });

  @override
  List<Object?> get props => [position, isInWaitingRoom];
}