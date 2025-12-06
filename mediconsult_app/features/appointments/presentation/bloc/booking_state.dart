import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_schedule.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/appointment.dart';

/// Base class for all booking states
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingInitial extends BookingState {
  const BookingInitial();
}

/// Loading state
class BookingLoading extends BookingState {
  const BookingLoading();
}

/// Doctors loaded state
class DoctorsLoaded extends BookingState {
  final List<DoctorSchedule> doctors;

  const DoctorsLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

/// Doctor schedule loaded state
class DoctorScheduleLoaded extends BookingState {
  final DoctorSchedule schedule;

  const DoctorScheduleLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Time slots loaded state
class TimeSlotsLoaded extends BookingState {
  final List<TimeSlot> timeSlots;
  final DateTime date;

  const TimeSlotsLoaded(this.timeSlots, this.date);

  @override
  List<Object?> get props => [timeSlots, date];
}

/// Time slot selected state
class TimeSlotSelectedState extends BookingState {
  final TimeSlot selectedTimeSlot;

  const TimeSlotSelectedState(this.selectedTimeSlot);

  @override
  List<Object?> get props => [selectedTimeSlot];
}

/// Booking confirmed state
class BookingConfirmed extends BookingState {
  final Appointment appointment;

  const BookingConfirmed(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// Error state
class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}