import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment.dart';
import '../entities/time_slot.dart';
import '../entities/doctor_schedule.dart';
import '../enums/appointment_status.dart';
import '../enums/consultation_type.dart';

/// Abstract repository for appointment operations
abstract class AppointmentsRepository {
  /// Get upcoming appointments for a patient
  Future<Either<Failure, List<Appointment>>> getUpcomingAppointments({
    required String patientId,
  });

  /// Get appointment history for a patient
  Future<Either<Failure, List<Appointment>>> getAppointmentHistory({
    required String patientId,
  });

  /// Get appointments for a doctor
  Future<Either<Failure, List<Appointment>>> getDoctorAppointments({
    required String doctorId,
    DateTime? date,
  });

  /// Search for doctors by specialty or name
  Future<Either<Failure, List<DoctorSchedule>>> searchDoctors({
    String? specialty,
    String? name,
    int limit = 20,
  });

  /// Get doctor's schedule/availability
  Future<Either<Failure, DoctorSchedule>> getDoctorSchedule({
    required String doctorId,
  });

  /// Get available time slots for a doctor on a specific date
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots({
    required String doctorId,
    required DateTime date,
  });

  /// Book a new appointment
  Future<Either<Failure, Appointment>> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required int durationMinutes,
    required ConsultationType type,
    String? notes,
  });

  /// Cancel an appointment
  Future<Either<Failure, void>> cancelAppointment({
    required String appointmentId,
    required String patientId,
  });

  /// Reschedule an appointment
  Future<Either<Failure, Appointment>> rescheduleAppointment({
    required String appointmentId,
    required String patientId,
    required DateTime newScheduledAt,
    required int newDurationMinutes,
  });

  /// Update appointment status (for doctor)
  Future<Either<Failure, Appointment>> updateAppointmentStatus({
    required String appointmentId,
    required String doctorId,
    required AppointmentStatus newStatus,
  });

  /// Join waiting room for an appointment
  Future<Either<Failure, void>> joinWaitingRoom({
    required String appointmentId,
    required String patientId,
  });

  /// Leave waiting room
  Future<Either<Failure, void>> leaveWaitingRoom({
    required String appointmentId,
    required String patientId,
  });

  /// Get waiting room position
  Future<Either<Failure, int>> getWaitingRoomPosition({
    required String appointmentId,
    required String patientId,
  });

  /// Send appointment reminder
  Future<Either<Failure, void>> sendAppointmentReminder({
    required String appointmentId,
  });
}
