import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/time_slot.dart';
import '../repositories/appointments_repository.dart';

/// Use case for getting available time slots
class GetAvailableTimeSlots {
  final AppointmentsRepository _repository;

  GetAvailableTimeSlots(this._repository);

  /// Execute the use case
  Future<Either<Failure, List<TimeSlot>>> call(GetAvailableTimeSlotsParams params) {
    return _repository.getAvailableTimeSlots(
      doctorId: params.doctorId,
      date: params.date,
    );
  }
}

/// Parameters for getting available time slots
class GetAvailableTimeSlotsParams extends Equatable {
  final String doctorId;
  final DateTime date;

  const GetAvailableTimeSlotsParams({
    required this.doctorId,
    required this.date,
  });

  @override
  List<Object?> get props => [doctorId, date];
}
