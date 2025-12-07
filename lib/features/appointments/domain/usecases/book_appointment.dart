import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../enums/consultation_type.dart';
import '../repositories/appointments_repository.dart';

/// Use case for booking a new appointment
class BookAppointment {
  final AppointmentsRepository _repository;

  BookAppointment(this._repository);

  /// Execute the use case
  Future<Either<Failure, Appointment>> call(BookAppointmentParams params) {
    return _repository.bookAppointment(
      patientId: params.patientId,
      doctorId: params.doctorId,
      scheduledAt: params.scheduledAt,
      durationMinutes: params.durationMinutes,
      type: params.type,
      notes: params.notes,
    );
  }
}

/// Parameters for booking an appointment
class BookAppointmentParams extends Equatable {
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final ConsultationType type;
  final String? notes;

  const BookAppointmentParams({
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.type,
    this.notes,
  });

  @override
  List<Object?> get props => [
        patientId,
        doctorId,
        scheduledAt,
        durationMinutes,
        type,
        notes,
      ];
}
