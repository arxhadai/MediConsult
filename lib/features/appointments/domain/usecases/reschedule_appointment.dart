import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

/// Use case for rescheduling an appointment
class RescheduleAppointment {
  final AppointmentsRepository _repository;

  RescheduleAppointment(this._repository);

  /// Execute the use case
  Future<Either<Failure, Appointment>> call(RescheduleAppointmentParams params) {
    return _repository.rescheduleAppointment(
      appointmentId: params.appointmentId,
      patientId: params.patientId,
      newScheduledAt: params.newScheduledAt,
      newDurationMinutes: params.newDurationMinutes,
    );
  }
}

/// Parameters for rescheduling an appointment
class RescheduleAppointmentParams extends Equatable {
  final String appointmentId;
  final String patientId;
  final DateTime newScheduledAt;
  final int newDurationMinutes;

  const RescheduleAppointmentParams({
    required this.appointmentId,
    required this.patientId,
    required this.newScheduledAt,
    required this.newDurationMinutes,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        patientId,
        newScheduledAt,
        newDurationMinutes,
      ];
}
