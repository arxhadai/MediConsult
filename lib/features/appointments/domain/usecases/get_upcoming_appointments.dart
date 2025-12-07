import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

/// Use case for getting upcoming appointments
class GetUpcomingAppointments {
  final AppointmentsRepository _repository;

  GetUpcomingAppointments(this._repository);

  /// Execute the use case
  Future<Either<Failure, List<Appointment>>> call(GetUpcomingAppointmentsParams params) {
    return _repository.getUpcomingAppointments(patientId: params.patientId);
  }
}

/// Parameters for getting upcoming appointments
class GetUpcomingAppointmentsParams extends Equatable {
  final String patientId;

  const GetUpcomingAppointmentsParams({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}
