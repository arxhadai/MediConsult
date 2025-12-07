import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

/// Use case for getting appointment history
class GetAppointmentHistory {
  final AppointmentsRepository _repository;

  GetAppointmentHistory(this._repository);

  /// Execute the use case
  Future<Either<Failure, List<Appointment>>> call(GetAppointmentHistoryParams params) {
    return _repository.getAppointmentHistory(patientId: params.patientId);
  }
}

/// Parameters for getting appointment history
class GetAppointmentHistoryParams extends Equatable {
  final String patientId;

  const GetAppointmentHistoryParams({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}
