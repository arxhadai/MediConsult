import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC for handling login flow
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginInitial()) {
    on<LoginPhoneSubmitted>(_onPhoneSubmitted);
    on<LoginOtpSubmitted>(_onOtpSubmitted);
    on<LoginEmailSubmitted>(_onEmailSubmitted);
    on<LoginGoogleRequested>(_onGoogleRequested);
    on<LoginPasswordResetRequested>(_onPasswordResetRequested);
    on<LoginOtpResendRequested>(_onOtpResendRequested);
    on<LoginErrorCleared>(_onErrorCleared);
  }

  Future<void> _onPhoneSubmitted(
    LoginPhoneSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Sending verification code...'));

    final result = await _authRepository.signInWithPhone(
      phoneNumber: event.phoneNumber,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (verificationId) => emit(LoginOtpSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
        sentAt: DateTime.now(),
      )),
    );
  }

  Future<void> _onOtpSubmitted(
    LoginOtpSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Verifying code...'));

    final result = await _authRepository.verifyOtp(
      verificationId: event.verificationId,
      otp: event.otp,
      role: event.role,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (user) => emit(LoginSuccess(user)),
    );
  }

  Future<void> _onEmailSubmitted(
    LoginEmailSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Signing in...'));

    final result = await _authRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (user) => emit(LoginSuccess(user)),
    );
  }

  Future<void> _onGoogleRequested(
    LoginGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Connecting to Google...'));

    final result = await _authRepository.signInWithGoogle(role: event.role);

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (user) => emit(LoginSuccess(user)),
    );
  }

  Future<void> _onPasswordResetRequested(
    LoginPasswordResetRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Sending reset link...'));

    final result = await _authRepository.sendPasswordResetEmail(
      email: event.email,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (_) => emit(LoginPasswordResetSent(event.email)),
    );
  }

  Future<void> _onOtpResendRequested(
    LoginOtpResendRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading(message: 'Resending verification code...'));

    final result = await _authRepository.signInWithPhone(
      phoneNumber: event.phoneNumber,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.toString())),
      (verificationId) => emit(LoginOtpSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
        sentAt: DateTime.now(),
      )),
    );
  }

  void _onErrorCleared(
    LoginErrorCleared event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginInitial());
  }
}
