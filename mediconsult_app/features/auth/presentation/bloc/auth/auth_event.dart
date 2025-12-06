import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check initial auth status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event when auth state changes
class AuthStateChanged extends AuthEvent {
  final User? user;

  const AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Event to sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event to refresh session
class AuthSessionRefreshRequested extends AuthEvent {
  const AuthSessionRefreshRequested();
}

/// Event when biometric authentication is requested
class AuthBiometricRequested extends AuthEvent {
  const AuthBiometricRequested();
}

/// Event to enable biometric authentication
class AuthBiometricEnableRequested extends AuthEvent {
  const AuthBiometricEnableRequested();
}

/// Event to disable biometric authentication
class AuthBiometricDisableRequested extends AuthEvent {
  const AuthBiometricDisableRequested();
}
