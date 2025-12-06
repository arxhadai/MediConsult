import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../enums/appointment_status.dart';
import '../repositories/appointments_repository.dart';

/// Use case for updating appointment status
class UpdateAppointmentStatus {
  final AppointmentsRepository _repository;

  UpdateAppointmentStatus(this._repository);

  /// Execute the use case
  Future<Either<Failure, Appointment>> call(UpdateAppointmentStatusParams params) {
    return _repository.updateAppointmentStatus(
      appointmentId: params.appointmentId,
      doctorId: params.doctorId,
      newStatus: params.newStatus,
    );
  }
}

/// Parameters for updating appointment status
class UpdateAppointmentStatusParams extends Equatable {
  final String appointmentId;
  final String doctorId;
  final AppointmentStatus newStatus;

  const UpdateAppointmentStatusParams({
    required this.appointmentId,
    required this.doctorId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [appointmentId, doctorId, newStatus];
}
