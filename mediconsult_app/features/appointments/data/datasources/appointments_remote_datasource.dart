import '../models/appointment_model.dart';
import '../models/time_slot_model.dart';
import '../models/doctor_schedule_model.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';

/// Abstract interface for remote appointments data source
abstract class AppointmentsRemoteDatasource {
  /// Get upcoming appointments for a patient
  Future<List<AppointmentModel>> getUpcomingAppointments({
    required String patientId,
  });

  /// Get appointment history for a patient
  Future<List<AppointmentModel>> getAppointmentHistory({
    required String patientId,
  });

  /// Get appointments for a doctor
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    DateTime? date,
  });

  /// Search for doctors by specialty or name
  Future<List<DoctorScheduleModel>> searchDoctors({
    String? specialty,
    String? name,
    int limit = 20,
  });

  /// Get doctor's schedule/availability
  Future<DoctorScheduleModel> getDoctorSchedule({
    required String doctorId,
  });

  /// Get available time slots for a doctor on a specific date
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String doctorId,
    required DateTime date,
  });

  /// Book a new appointment
  Future<AppointmentModel> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required int durationMinutes,
    required ConsultationType type,
    String? notes,
  });

  /// Cancel an appointment
  Future<void> cancelAppointment({
    required String appointmentId,
    required String patientId,
  });

  /// Reschedule an appointment
  Future<AppointmentModel> rescheduleAppointment({
    required String appointmentId,
    required String patientId,
    required DateTime newScheduledAt,
    required int newDurationMinutes,
  });

  /// Update appointment status (for doctor)
  Future<AppointmentModel> updateAppointmentStatus({
    required String appointmentId,
    required String doctorId,
    required AppointmentStatus newStatus,
  });

  /// Join waiting room for an appointment
  Future<void> joinWaitingRoom({
    required String appointmentId,
    required String patientId,
  });

  /// Leave waiting room
  Future<void> leaveWaitingRoom({
    required String appointmentId,
    required String patientId,
  });

  /// Get waiting room position
  Future<int> getWaitingRoomPosition({
    required String appointmentId,
    required String patientId,
  });

  /// Send appointment reminder
  Future<void> sendAppointmentReminder({
    required String appointmentId,
  });
}
