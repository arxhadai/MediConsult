import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/appointments_repository.dart';

/// Use case for cancelling an appointment
class CancelAppointment {
  final AppointmentsRepository _repository;

  CancelAppointment(this._repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(CancelAppointmentParams params) {
    return _repository.cancelAppointment(
      appointmentId: params.appointmentId,
      patientId: params.patientId,
    );
  }
}

/// Parameters for cancelling an appointment
class CancelAppointmentParams extends Equatable {
  final String appointmentId;
  final String patientId;

  const CancelAppointmentParams({
    required this.appointmentId,
    required this.patientId,
  });

  @override
  List<Object?> get props => [appointmentId, patientId];
}
