import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Base class for all auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State while checking auth status
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final User user;
  final bool requiresProfileSetup;
  final bool requiresVerification;

  const AuthAuthenticated({
    required this.user,
    this.requiresProfileSetup = false,
    this.requiresVerification = false,
  });

  @override
  List<Object?> get props => [user, requiresProfileSetup, requiresVerification];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  final bool biometricAvailable;
  final bool biometricEnabled;

  const AuthUnauthenticated({
    this.biometricAvailable = false,
    this.biometricEnabled = false,
  });

  @override
  List<Object?> get props => [biometricAvailable, biometricEnabled];
}

/// State when session has expired
class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();
}

/// State when there's an auth error
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for biometric authentication progress
class AuthBiometricInProgress extends AuthState {
  const AuthBiometricInProgress();
}
