import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/appointments_repository.dart';

/// Use case for joining waiting room
class JoinWaitingRoom {
  final AppointmentsRepository _repository;

  JoinWaitingRoom(this._repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(JoinWaitingRoomParams params) {
    return _repository.joinWaitingRoom(
      appointmentId: params.appointmentId,
      patientId: params.patientId,
    );
  }
}

/// Parameters for joining waiting room
class JoinWaitingRoomParams extends Equatable {
  final String appointmentId;
  final String patientId;

  const JoinWaitingRoomParams({
    required this.appointmentId,
    required this.patientId,
  });

  @override
  List<Object?> get props => [appointmentId, patientId];
}
