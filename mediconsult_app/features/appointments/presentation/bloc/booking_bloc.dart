import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/appointments_repository.dart';
import '../../../../core/errors/failures.dart';
import 'booking_event.dart';
import 'booking_state.dart';

/// BLoC for managing appointment booking flow
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final AppointmentsRepository _appointmentsRepository;

  BookingBloc({required AppointmentsRepository appointmentsRepository})
      : _appointmentsRepository = appointmentsRepository,
        super(const BookingInitial()) {
    on<DoctorSearchRequested>(_onDoctorSearchRequested);
    on<DoctorScheduleLoadRequested>(_onDoctorScheduleLoadRequested);
    on<TimeSlotsLoadRequested>(_onTimeSlotsLoadRequested);
    on<TimeSlotSelected>(_onTimeSlotSelected);
    on<AppointmentBookingRequested>(_onAppointmentBookingRequested);
    on<BookingClearRequested>(_onBookingClearRequested);
  }

  Future<void> _onDoctorSearchRequested(
    DoctorSearchRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _appointmentsRepository.searchDoctors(
      specialty: event.specialty,
      name: event.name,
    );

    result.fold(
      (failure) => emit(BookingError(_mapFailureToMessage(failure))),
      (doctors) => emit(DoctorsLoaded(doctors)),
    );
  }

  Future<void> _onDoctorScheduleLoadRequested(
    DoctorScheduleLoadRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _appointmentsRepository.getDoctorSchedule(
      doctorId: event.doctorId,
    );

    result.fold(
      (failure) => emit(BookingError(_mapFailureToMessage(failure))),
      (schedule) => emit(DoctorScheduleLoaded(schedule)),
    );
  }

  Future<void> _onTimeSlotsLoadRequested(
    TimeSlotsLoadRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _appointmentsRepository.getAvailableTimeSlots(
      doctorId: event.doctorId,
      date: event.date,
    );

    result.fold(
      (failure) => emit(BookingError(_mapFailureToMessage(failure))),
      (timeSlots) => emit(TimeSlotsLoaded(timeSlots, event.date)),
    );
  }

  Future<void> _onTimeSlotSelected(
    TimeSlotSelected event,
    Emitter<BookingState> emit,
  ) async {
    emit(TimeSlotSelectedState(event.timeSlot));
  }

  Future<void> _onAppointmentBookingRequested(
    AppointmentBookingRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _appointmentsRepository.bookAppointment(
      patientId: event.patientId,
      doctorId: event.doctorId,
      scheduledAt: event.scheduledAt,
      durationMinutes: event.durationMinutes,
      type: event.type,
      notes: event.notes,
    );

    result.fold(
      (failure) => emit(BookingError(_mapFailureToMessage(failure))),
      (appointment) => emit(BookingConfirmed(appointment)),
    );
  }

  Future<void> _onBookingClearRequested(
    BookingClearRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred. Please try again later.';
    } else if (failure is CacheFailure) {
      return 'Cache error occurred. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }
}