import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/appointments_repository.dart';
import '../../../../core/errors/failures.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

/// BLoC for managing appointment state
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentsRepository _appointmentsRepository;

  AppointmentBloc({required AppointmentsRepository appointmentsRepository})
      : _appointmentsRepository = appointmentsRepository,
        super(const AppointmentInitial()) {
    on<AppointmentsLoadRequested>(_onAppointmentsLoadRequested);
    on<AppointmentHistoryLoadRequested>(_onAppointmentHistoryLoadRequested);
    on<DoctorAppointmentsLoadRequested>(_onDoctorAppointmentsLoadRequested);
    on<AppointmentsRefreshRequested>(_onAppointmentsRefreshRequested);
    on<AppointmentCancelRequested>(_onAppointmentCancelRequested);
    on<WaitingRoomJoinRequested>(_onWaitingRoomJoinRequested);
    on<WaitingRoomLeaveRequested>(_onWaitingRoomLeaveRequested);
    on<WaitingRoomPositionRequested>(_onWaitingRoomPositionRequested);
  }

  Future<void> _onAppointmentsLoadRequested(
    AppointmentsLoadRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());

    final result = await _appointmentsRepository.getUpcomingAppointments(
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (appointments) => emit(AppointmentsLoaded(appointments: appointments)),
    );
  }

  Future<void> _onAppointmentHistoryLoadRequested(
    AppointmentHistoryLoadRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());

    final result = await _appointmentsRepository.getAppointmentHistory(
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (appointments) => emit(
        AppointmentsLoaded(
          appointments: appointments,
          isHistory: true,
        ),
      ),
    );
  }

  Future<void> _onDoctorAppointmentsLoadRequested(
    DoctorAppointmentsLoadRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());

    final result = await _appointmentsRepository.getDoctorAppointments(
      doctorId: event.doctorId,
      date: event.date,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (appointments) => emit(
        DoctorAppointmentsLoaded(
          appointments: appointments,
          doctorId: event.doctorId,
        ),
      ),
    );
  }

  Future<void> _onAppointmentsRefreshRequested(
    AppointmentsRefreshRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    // This would typically trigger a refresh of the current state
    // For now, we'll just re-emit the current state
    emit(state);
  }

  Future<void> _onAppointmentCancelRequested(
    AppointmentCancelRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final currentState = state;

    final result = await _appointmentsRepository.cancelAppointment(
      appointmentId: event.appointmentId,
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (_) {
        // If we were displaying appointments, refresh them
        if (currentState is AppointmentsLoaded) {
          add(AppointmentsLoadRequested(event.patientId));
        } else if (currentState is DoctorAppointmentsLoaded) {
          add(DoctorAppointmentsLoadRequested(currentState.doctorId));
        } else {
          emit(const AppointmentInitial());
        }
      },
    );
  }

  Future<void> _onWaitingRoomJoinRequested(
    WaitingRoomJoinRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await _appointmentsRepository.joinWaitingRoom(
      appointmentId: event.appointmentId,
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (_) => emit(const WaitingRoomState(
        position: 1, // Position will be updated when we get it
        isInWaitingRoom: true,
      )),
    );
  }

  Future<void> _onWaitingRoomLeaveRequested(
    WaitingRoomLeaveRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await _appointmentsRepository.leaveWaitingRoom(
      appointmentId: event.appointmentId,
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (_) => emit(const WaitingRoomState(
        position: 0,
        isInWaitingRoom: false,
      )),
    );
  }

  Future<void> _onWaitingRoomPositionRequested(
    WaitingRoomPositionRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await _appointmentsRepository.getWaitingRoomPosition(
      appointmentId: event.appointmentId,
      patientId: event.patientId,
    );

    result.fold(
      (failure) => emit(AppointmentError(_mapFailureToMessage(failure))),
      (position) => emit(WaitingRoomState(
        position: position,
        isInWaitingRoom: true,
      )),
    );
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