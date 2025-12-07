import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/appointments_repository.dart';

/// Use case for getting waiting room position
class GetWaitingRoomPosition {
  final AppointmentsRepository _repository;

  GetWaitingRoomPosition(this._repository);

  /// Execute the use case
  Future<Either<Failure, int>> call(GetWaitingRoomPositionParams params) {
    return _repository.getWaitingRoomPosition(
      appointmentId: params.appointmentId,
      patientId: params.patientId,
    );
  }
}

/// Parameters for getting waiting room position
class GetWaitingRoomPositionParams extends Equatable {
  final String appointmentId;
  final String patientId;

  const GetWaitingRoomPositionParams({
    required this.appointmentId,
    required this.patientId,
  });

  @override
  List<Object?> get props => [appointmentId, patientId];
}
