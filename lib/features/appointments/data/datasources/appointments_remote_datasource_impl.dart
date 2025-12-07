import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../models/appointment_model.dart';
import '../models/time_slot_model.dart';
import '../models/doctor_schedule_model.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';
import 'appointments_remote_datasource.dart';

/// Implementation of AppointmentsRemoteDatasource using Firestore
@LazySingleton(as: AppointmentsRemoteDatasource)
class AppointmentsRemoteDatasourceImpl implements AppointmentsRemoteDatasource {
  final FirebaseFirestore _firestore;

  AppointmentsRemoteDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments({
    required String patientId,
  }) async {
    final now = DateTime.now();
    final querySnapshot = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where('scheduledAt', isGreaterThan: now)
        .where('status', whereIn: ['pending', 'confirmed'])
        .orderBy('scheduledAt')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final json = <String, dynamic>{
        'id': doc.id,
      };
      // ignore: unnecessary_null_comparison, unnecessary_cast
      json.addAll(data as Map<String, dynamic>);
      return AppointmentModel.fromJson(json);
    }).toList();
  }

  @override
  Future<List<AppointmentModel>> getAppointmentHistory({
    required String patientId,
  }) async {
    final now = DateTime.now();
    final querySnapshot = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where('scheduledAt', isLessThan: now)
        .orderBy('scheduledAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final json = <String, dynamic>{
        'id': doc.id,
      };
      // ignore: unnecessary_null_comparison, unnecessary_cast
      json.addAll(data as Map<String, dynamic>);
      return AppointmentModel.fromJson(json);
    }).toList();
  }

  @override
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    DateTime? date,
  }) async {
    Query query = _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId);

    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      query = query
          .where('scheduledAt', isGreaterThanOrEqualTo: startOfDay)
          .where('scheduledAt', isLessThan: endOfDay);
    }

    final querySnapshot = await query.orderBy('scheduledAt').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final json = <String, dynamic>{
        'id': doc.id,
      };
      // ignore: unnecessary_null_comparison, unnecessary_cast
      json.addAll(data as Map<String, dynamic>);
      return AppointmentModel.fromJson(json);
    }).toList();
  }

  @override
  Future<List<DoctorScheduleModel>> searchDoctors({
    String? specialty,
    String? name,
    int limit = 20,
  }) async {
    Query query = _firestore.collection('doctors');

    if (specialty != null && specialty.isNotEmpty) {
      query = query.where('specialty', isEqualTo: specialty);
    }

    if (name != null && name.isNotEmpty) {
      // Note: This is a simplified search. In production, you'd use Firestore text search
      query = query.where('doctorName', isGreaterThanOrEqualTo: name);
    }

    final querySnapshot =
        await query.limit(limit).orderBy('rating', descending: true).get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final json = <String, dynamic>{
        'doctorId': doc.id,
      };
      // ignore: unnecessary_null_comparison, unnecessary_cast
      json.addAll(data as Map<String, dynamic>);
      return DoctorScheduleModel.fromJson(json);
    }).toList();
  }

  @override
  Future<DoctorScheduleModel> getDoctorSchedule({
    required String doctorId,
  }) async {
    final docSnapshot =
        await _firestore.collection('doctors').doc(doctorId).get();

    if (!docSnapshot.exists) {
      throw Exception('Doctor not found');
    }

    final data = docSnapshot.data();

    final json = <String, dynamic>{
      'doctorId': docSnapshot.id,
    };
    // ignore: unnecessary_null_comparison, unnecessary_cast
    json.addAll(data as Map<String, dynamic>);
    return DoctorScheduleModel.fromJson(json);
  }

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    // Get doctor's schedule
    final doctorSchedule = await getDoctorSchedule(doctorId: doctorId);

    // Get existing appointments for this date
    final appointments = await getDoctorAppointments(
      doctorId: doctorId,
      date: date,
    );

    // Generate time slots based on doctor's working hours
    final workingHours = doctorSchedule.todaysHours;
    if (workingHours == null) {
      return [];
    }

    final slots = <TimeSlotModel>[];
    final startTime = DateTime(
      date.year,
      date.month,
      date.day,
      workingHours.startTime.hour,
      workingHours.startTime.minute,
    );
    final endTime = DateTime(
      date.year,
      date.month,
      date.day,
      workingHours.endTime.hour,
      workingHours.endTime.minute,
    );

    // Generate 30-minute slots
    var currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      final slotEndTime = currentTime.add(const Duration(minutes: 30));

      // Check if slot is occupied
      final isOccupied = appointments.any((appointment) {
        return appointment.scheduledAt.isAtSameMomentAs(currentTime) ||
            (appointment.scheduledAt.isAfter(currentTime) &&
                appointment.scheduledAt.isBefore(slotEndTime));
      });

      slots.add(TimeSlotModel(
        id: const Uuid().v4(),
        startTime: currentTime,
        endTime: slotEndTime,
        isAvailable: !isOccupied,
        doctorId: doctorId,
      ));

      currentTime = slotEndTime;
    }

    return slots;
  }

  @override
  Future<AppointmentModel> bookAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    required int durationMinutes,
    required ConsultationType type,
    String? notes,
  }) async {
    // Validate time slot is available
    final date = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
    final availableSlots = await getAvailableTimeSlots(
      doctorId: doctorId,
      date: date,
    );

    final isSlotAvailable = availableSlots.any((slot) =>
        slot.startTime.isAtSameMomentAs(scheduledAt) && slot.isAvailable);

    if (!isSlotAvailable) {
      throw Exception('Selected time slot is not available');
    }

    // Create appointment
    final appointment = AppointmentModel(
      id: const Uuid().v4(),
      patientId: patientId,
      doctorId: doctorId,
      doctorName: '', // Will be populated from doctor data
      doctorSpecialty: '', // Will be populated from doctor data
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      status: AppointmentStatus.confirmed,
      type: type,
      notes: notes,
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestore.collection('appointments').doc(appointment.id).set(
          appointment.toJson(),
        );

    // In a real implementation, we would populate doctorName and doctorSpecialty
    // from the doctor's document. For now, we'll leave them empty.

    return appointment;
  }

  @override
  Future<void> cancelAppointment({
    required String appointmentId,
    required String patientId,
  }) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': AppointmentStatus.cancelled.value});
  }

  @override
  Future<AppointmentModel> rescheduleAppointment({
    required String appointmentId,
    required String patientId,
    required DateTime newScheduledAt,
    required int newDurationMinutes,
  }) async {
    // Update appointment
    await _firestore.collection('appointments').doc(appointmentId).update({
      'scheduledAt': newScheduledAt.toIso8601String(),
      'durationMinutes': newDurationMinutes,
      'status': AppointmentStatus.rescheduled.value,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Get updated appointment
    final docSnapshot =
        await _firestore.collection('appointments').doc(appointmentId).get();

    final data = docSnapshot.data();
    if (data == null) throw Exception('Document data is null');

    return AppointmentModel.fromJson({
      'id': docSnapshot.id,
      ...data,
    });
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus({
    required String appointmentId,
    required String doctorId,
    required AppointmentStatus newStatus,
  }) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': newStatus.value,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Get updated appointment
    final docSnapshot =
        await _firestore.collection('appointments').doc(appointmentId).get();

    final data = docSnapshot.data();
    if (data == null) throw Exception('Document data is null');

    return AppointmentModel.fromJson({
      'id': docSnapshot.id,
      ...data,
    });
  }

  @override
  Future<void> joinWaitingRoom({
    required String appointmentId,
    required String patientId,
  }) async {
    // Add patient to waiting room queue
    await _firestore
        .collection('waiting_rooms')
        .doc(appointmentId)
        .collection('patients')
        .doc(patientId)
        .set({
      'joinedAt': FieldValue.serverTimestamp(),
      'patientId': patientId,
    });
  }

  @override
  Future<void> leaveWaitingRoom({
    required String appointmentId,
    required String patientId,
  }) async {
    await _firestore
        .collection('waiting_rooms')
        .doc(appointmentId)
        .collection('patients')
        .doc(patientId)
        .delete();
  }

  @override
  Future<int> getWaitingRoomPosition({
    required String appointmentId,
    required String patientId,
  }) async {
    final querySnapshot = await _firestore
        .collection('waiting_rooms')
        .doc(appointmentId)
        .collection('patients')
        .orderBy('joinedAt')
        .get();

    final patientIds = querySnapshot.docs
        .map((doc) => doc.data()['patientId'] as String)
        .toList();

    return patientIds.indexOf(patientId) + 1;
  }

  @override
  Future<void> sendAppointmentReminder({
    required String appointmentId,
  }) async {
    // In a real implementation, this would send a notification
    // For now, we'll just log it
    // ignore: avoid_print
    print('Sending reminder for appointment: $appointmentId');
  }
}
