import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing global authentication state
@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSessionRefreshRequested>(_onSessionRefreshRequested);
    on<AuthBiometricRequested>(_onBiometricRequested);
    on<AuthBiometricEnableRequested>(_onBiometricEnableRequested);
    on<AuthBiometricDisableRequested>(_onBiometricDisableRequested);

    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.getCurrentUser();

    await result.fold(
      (failure) async {
        if (failure.toString().contains('session-expired')) {
          emit(const AuthSessionExpired());
        } else {
          final biometricAvailable =
              await _authRepository.isBiometricAvailable();
          final biometricEnabled = await _authRepository.isBiometricEnabled();
          emit(AuthUnauthenticated(
            biometricAvailable: biometricAvailable,
            biometricEnabled: biometricEnabled,
          ));
        }
      },
      (user) async {
        if (user != null) {
          emit(AuthAuthenticated(
            user: user,
            requiresProfileSetup: !user.hasCompletedProfile,
            requiresVerification: !user.isFullyVerified,
          ));
        } else {
          final biometricAvailable =
              await _authRepository.isBiometricAvailable();
          final biometricEnabled = await _authRepository.isBiometricEnabled();
          emit(AuthUnauthenticated(
            biometricAvailable: biometricAvailable,
            biometricEnabled: biometricEnabled,
          ));
        }
      },
    );
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthAuthenticated(
        user: event.user!,
        requiresProfileSetup: !event.user!.hasCompletedProfile,
        requiresVerification: !event.user!.isFullyVerified,
      ));
    } else {
      final biometricAvailable = await _authRepository.isBiometricAvailable();
      final biometricEnabled = await _authRepository.isBiometricEnabled();
      emit(AuthUnauthenticated(
        biometricAvailable: biometricAvailable,
        biometricEnabled: biometricEnabled,
      ));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) async {
        final biometricAvailable = await _authRepository.isBiometricAvailable();
        final biometricEnabled = await _authRepository.isBiometricEnabled();
        emit(AuthUnauthenticated(
          biometricAvailable: biometricAvailable,
          biometricEnabled: biometricEnabled,
        ));
      },
    );
  }

  Future<void> _onSessionRefreshRequested(
    AuthSessionRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.checkAndRefreshSession();

    result.fold(
      (failure) {
        if (failure.toString().contains('session-expired')) {
          emit(const AuthSessionExpired());
        }
      },
      (_) {
        // Session is still valid, no state change needed
      },
    );
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthBiometricInProgress());

    final result = await _authRepository.authenticateWithBiometric();

    result.fold(
      (failure) async {
        final biometricAvailable = await _authRepository.isBiometricAvailable();
        final biometricEnabled = await _authRepository.isBiometricEnabled();
        emit(AuthUnauthenticated(
          biometricAvailable: biometricAvailable,
          biometricEnabled: biometricEnabled,
        ));
      },
      (user) {
        emit(AuthAuthenticated(
          user: user,
          requiresProfileSetup: !user.hasCompletedProfile,
          requiresVerification: !user.isFullyVerified,
        ));
      },
    );
  }

  Future<void> _onBiometricEnableRequested(
    AuthBiometricEnableRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;

    final result = await _authRepository.enableBiometric();

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthAuthenticated(
        user: currentState.user.copyWith(isBiometricEnabled: true),
        requiresProfileSetup: currentState.requiresProfileSetup,
        requiresVerification: currentState.requiresVerification,
      )),
    );
  }

  Future<void> _onBiometricDisableRequested(
    AuthBiometricDisableRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;

    final result = await _authRepository.disableBiometric();

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthAuthenticated(
        user: currentState.user.copyWith(isBiometricEnabled: false),
        requiresProfileSetup: currentState.requiresProfileSetup,
        requiresVerification: currentState.requiresVerification,
      )),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
