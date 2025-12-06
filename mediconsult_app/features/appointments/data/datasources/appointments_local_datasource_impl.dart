import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/appointment_model.dart';
import '../models/time_slot_model.dart';
import '../models/doctor_schedule_model.dart';
import 'appointments_local_datasource.dart';

/// Implementation of AppointmentsLocalDatasource using SharedPreferences
class AppointmentsLocalDatasourceImpl implements AppointmentsLocalDatasource {
  final SharedPreferences _prefs;

  AppointmentsLocalDatasourceImpl({required SharedPreferences prefs})
      : _prefs = prefs;

  // Keys for caching
  static const String _upcomingAppointmentsKey = 'upcoming_appointments';
  static const String _appointmentHistoryKey = 'appointment_history';
  static const String _doctorAppointmentsKey = 'doctor_appointments';
  static const String _doctorSchedulePrefix = 'doctor_schedule_';
  static const String _timeSlotsPrefix = 'time_slots_';

  @override
  Future<void> cacheUpcomingAppointments(List<AppointmentModel> appointments) async {
    final jsonList = appointments.map((a) => a.toJson()).toList();
    await _prefs.setString(_upcomingAppointmentsKey, json.encode(jsonList));
  }

  @override
  Future<List<AppointmentModel>> getCachedUpcomingAppointments() async {
    final jsonString = _prefs.getString(_upcomingAppointmentsKey);
    if (jsonString == null) return [];

    final jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearCachedUpcomingAppointments() async {
    await _prefs.remove(_upcomingAppointmentsKey);
  }

  @override
  Future<void> cacheAppointmentHistory(List<AppointmentModel> appointments) async {
    final jsonList = appointments.map((a) => a.toJson()).toList();
    await _prefs.setString(_appointmentHistoryKey, json.encode(jsonList));
  }

  @override
  Future<List<AppointmentModel>> getCachedAppointmentHistory() async {
    final jsonString = _prefs.getString(_appointmentHistoryKey);
    if (jsonString == null) return [];

    final jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearCachedAppointmentHistory() async {
    await _prefs.remove(_appointmentHistoryKey);
  }

  @override
  Future<void> cacheDoctorAppointments(List<AppointmentModel> appointments) async {
    final jsonList = appointments.map((a) => a.toJson()).toList();
    await _prefs.setString(_doctorAppointmentsKey, json.encode(jsonList));
  }

  @override
  Future<List<AppointmentModel>> getCachedDoctorAppointments() async {
    final jsonString = _prefs.getString(_doctorAppointmentsKey);
    if (jsonString == null) return [];

    final jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearCachedDoctorAppointments() async {
    await _prefs.remove(_doctorAppointmentsKey);
  }

  @override
  Future<void> cacheDoctorSchedule(DoctorScheduleModel schedule) async {
    final key = '$_doctorSchedulePrefix${schedule.doctorId}';
    await _prefs.setString(key, json.encode(schedule.toJson()));
  }

  @override
  Future<DoctorScheduleModel?> getCachedDoctorSchedule(String doctorId) async {
    final key = '$_doctorSchedulePrefix$doctorId';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return DoctorScheduleModel.fromJson(jsonData);
  }

  @override
  Future<void> clearCachedDoctorSchedule(String doctorId) async {
    final key = '$_doctorSchedulePrefix$doctorId';
    await _prefs.remove(key);
  }

  @override
  Future<void> cacheAvailableTimeSlots(
    String doctorId,
    DateTime date,
    List<TimeSlotModel> slots,
  ) async {
    final key = '$_timeSlotsPrefix${doctorId}_${date.toIso8601String()}';
    final jsonList = slots.map((s) => s.toJson()).toList();
    await _prefs.setString(key, json.encode(jsonList));
  }

  @override
  Future<List<TimeSlotModel>> getCachedAvailableTimeSlots(
    String doctorId,
    DateTime date,
  ) async {
    final key = '$_timeSlotsPrefix${doctorId}_${date.toIso8601String()}';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return [];

    final jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData
        .map((item) => TimeSlotModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearCachedTimeSlots(String doctorId, DateTime date) async {
    final key = '$_timeSlotsPrefix${doctorId}_${date.toIso8601String()}';
    await _prefs.remove(key);
  }
}