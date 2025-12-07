import '../models/appointment_model.dart';
import '../models/time_slot_model.dart';
import '../models/doctor_schedule_model.dart';

/// Abstract interface for local appointments data source
abstract class AppointmentsLocalDatasource {
  /// Cache upcoming appointments
  Future<void> cacheUpcomingAppointments(List<AppointmentModel> appointments);

  /// Get cached upcoming appointments
  Future<List<AppointmentModel>> getCachedUpcomingAppointments();

  /// Clear cached upcoming appointments
  Future<void> clearCachedUpcomingAppointments();

  /// Cache appointment history
  Future<void> cacheAppointmentHistory(List<AppointmentModel> appointments);

  /// Get cached appointment history
  Future<List<AppointmentModel>> getCachedAppointmentHistory();

  /// Clear cached appointment history
  Future<void> clearCachedAppointmentHistory();

  /// Cache doctor appointments
  Future<void> cacheDoctorAppointments(List<AppointmentModel> appointments);

  /// Get cached doctor appointments
  Future<List<AppointmentModel>> getCachedDoctorAppointments();

  /// Clear cached doctor appointments
  Future<void> clearCachedDoctorAppointments();

  /// Cache doctor schedule
  Future<void> cacheDoctorSchedule(DoctorScheduleModel schedule);

  /// Get cached doctor schedule
  Future<DoctorScheduleModel?> getCachedDoctorSchedule(String doctorId);

  /// Clear cached doctor schedule
  Future<void> clearCachedDoctorSchedule(String doctorId);

  /// Cache available time slots
  Future<void> cacheAvailableTimeSlots(
    String doctorId,
    DateTime date,
    List<TimeSlotModel> slots,
  );

  /// Get cached available time slots
  Future<List<TimeSlotModel>> getCachedAvailableTimeSlots(
    String doctorId,
    DateTime date,
  );

  /// Clear cached time slots
  Future<void> clearCachedTimeSlots(String doctorId, DateTime date);
}