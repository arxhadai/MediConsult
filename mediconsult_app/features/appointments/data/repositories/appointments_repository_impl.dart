import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/doctor_schedule.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_datasource.dart';
import '../datasources/appointments_local_datasource.dart';

/// Implementation of AppointmentsRepository
class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDatasource _remoteDatasource;
  final AppointmentsLocalDatasource _localDatasource;

  AppointmentsRepositoryImpl({
    required AppointmentsRemoteDatasource remoteDatasource,
    required AppointmentsLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<Either<Failure, List<Appointment>>> getUpcomingAppointments({
    required String patientId,
  }) async {
    try {
      // Try to get from remote
      final appointments = await _remoteDatasource.getUpcomingAppointments(
        patientId: patientId,
      );

      // Cache the results
      await _localDatasource.cacheUpcomingAppointments(appointments);

      // Convert to entities
      return Right(appointments.map((a) => a.toEntity()).toList());
    } catch (e) {
      // Try to get from cache
      try {
        final cachedAppointments =
            await _localDatasource.getCachedUpcomingAppointments();
        return Right(cachedAppointments.map((a) => a.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure('Failed to load cached appointments'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> getAppointmentHistory({
    required String patientId,
  }) async {
    try {
      // Try to get from remote
      final appointments = await _remoteDatasource.getAppointmentHistory(
        patientId: patientId,
      );

      // Cache the results
      await _localDatasource.cacheAppointmentHistory(appointments);

      // Convert to entities
      return Right(appointments.map((a) => a.toEntity()).toList());
    } catch (e) {
      // Try to get from cache
      try {
        final cachedAppointments =
            await _localDatasource.getCachedAppointmentHistory();
        return Right(cachedAppointments.map((a) => a.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure('An unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> getDoctorAppointments({
    required String doctorId,
    DateTime? date,
  }) async {
    try {
      // Try to get from remote
      final appointments = await _remoteDatasource.getDoctorAppointments(
        doctorId: doctorId,
        date: date,
      );

      // Cache the results
      await _localDatasource.cacheDoctorAppointments(appointments);

      // Convert to entities
      return Right(appointments.map((a) => a.toEntity()).toList());
    } catch (e) {
      // Try to get from cache
      try {
        final cachedAppointments =
            await _localDatasource.getCachedDoctorAppointments();
        return Right(cachedAppointments.map((a) => a.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure('An unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, List<DoctorSchedule>>> searchDoctors({
    String? specialty,
    String? name,
    int limit = 20,
  }) async {
    try {
      final doctors = await _remoteDatasource.searchDoctors(
        specialty: specialty,
        name: name,
        limit: limit,
      );

      // Convert to entities
      return Right(doctors.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DoctorSchedule>> getDoctorSchedule({
    required String doctorId,
  }) async {
    try {
      // Try to get from remote
      final schedule = await _remoteDatasource.getDoctorSchedule(
        doctorId: doctorId,
      );

      // Cache the result
      await _localDatasource.cacheDoctorSchedule(schedule);

      // Convert to entity
      return Right(schedule.toEntity());
    } catch (e) {
      // Try to get from cache
      try {
        final cachedSchedule =
            await _localDatasource.getCachedDoctorSchedule(doctorId);
        if (cachedSchedule != null) {
          return Right(cachedSchedule.toEntity());
        }
        return Left(ServerFailure('An unexpected error occurred'));
      } catch (cacheError) {
        return Left(ServerFailure('An unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      // Try to get from remote
      final slots = await _remoteDatasource.getAvailableTimeSlots(
        doctorId: doctorId,
        date: date,
      );

      // Cache the results
      await _localDatasource.cacheAvailableTimeSlots(doctorId, date, slots);

      // Convert to entities
      return Right(slots.map((s) => s.toEntity()).toList());
    } catch (e) {
      // Try to get from cache
      try {
        final cachedSlots =
            await _localDatasource.getCachedAvailableTimeSlots(doctorId, date);
        return Right(cachedSlots.map((s) => s.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure('An unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, Appointment>> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required int durationMinutes,
    required ConsultationType type,
    String? notes,
  }) async {
    try {
      final appointment = await _remoteDatasource.bookAppointment(
        patientId: patientId,
        doctorId: doctorId,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        type: type,
        notes: notes,
      );

      // Clear cached data that might be affected
      await _localDatasource.clearCachedUpcomingAppointments();
      await _localDatasource.clearCachedDoctorAppointments();

      // Convert to entity
      return Right(appointment.toEntity());
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment({
    required String appointmentId,
    required String patientId,
  }) async {
    try {
      await _remoteDatasource.cancelAppointment(
        appointmentId: appointmentId,
        patientId: patientId,
      );

      // Clear cached data that might be affected
      await _localDatasource.clearCachedUpcomingAppointments();
      await _localDatasource.clearCachedDoctorAppointments();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Appointment>> rescheduleAppointment({
    required String appointmentId,
    required String patientId,
    required DateTime newScheduledAt,
    required int newDurationMinutes,
  }) async {
    try {
      final appointment = await _remoteDatasource.rescheduleAppointment(
        appointmentId: appointmentId,
        patientId: patientId,
        newScheduledAt: newScheduledAt,
        newDurationMinutes: newDurationMinutes,
      );

      // Clear cached data that might be affected
      await _localDatasource.clearCachedUpcomingAppointments();
      await _localDatasource.clearCachedDoctorAppointments();

      // Convert to entity
      return Right(appointment.toEntity());
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Appointment>> updateAppointmentStatus({
    required String appointmentId,
    required String doctorId,
    required AppointmentStatus newStatus,
  }) async {
    try {
      final appointment = await _remoteDatasource.updateAppointmentStatus(
        appointmentId: appointmentId,
        doctorId: doctorId,
        newStatus: newStatus,
      );

      // Clear cached data that might be affected
      await _localDatasource.clearCachedUpcomingAppointments();
      await _localDatasource.clearCachedDoctorAppointments();

      // Convert to entity
      return Right(appointment.toEntity());
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> joinWaitingRoom({
    required String appointmentId,
    required String patientId,
  }) async {
    try {
      await _remoteDatasource.joinWaitingRoom(
        appointmentId: appointmentId,
        patientId: patientId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveWaitingRoom({
    required String appointmentId,
    required String patientId,
  }) async {
    try {
      await _remoteDatasource.leaveWaitingRoom(
        appointmentId: appointmentId,
        patientId: patientId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, int>> getWaitingRoomPosition({
    required String appointmentId,
    required String patientId,
  }) async {
    try {
      final position = await _remoteDatasource.getWaitingRoomPosition(
        appointmentId: appointmentId,
        patientId: patientId,
      );

      return Right(position);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> sendAppointmentReminder({
    required String appointmentId,
  }) async {
    try {
      await _remoteDatasource.sendAppointmentReminder(
        appointmentId: appointmentId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}