import 'package:equatable/equatable.dart';

/// Base failure class for all application failures
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Failure for server-side errors
class ServerFailure extends Failure {
  final String message;
  
  ServerFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'ServerFailure: $message';
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  final String message;
  
  CacheFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'CacheFailure: $message';
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  final String message;
  
  NetworkFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'NetworkFailure: $message';
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final String message;
  
  ValidationFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'ValidationFailure: $message';
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  final String message;
  final String? code;
  
  AuthFailure(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
  
  @override
  String toString() => 'AuthFailure: $message';

  /// Common auth failure factories
  factory AuthFailure.invalidCredentials() =>
      AuthFailure('Invalid email or password', code: 'invalid-credentials');
  
  factory AuthFailure.userNotFound() =>
      AuthFailure('No user found with this email', code: 'user-not-found');
  
  factory AuthFailure.emailAlreadyInUse() =>
      AuthFailure('Email is already registered', code: 'email-already-in-use');
  
  factory AuthFailure.weakPassword() =>
      AuthFailure('Password is too weak', code: 'weak-password');
  
  factory AuthFailure.invalidOtp() =>
      AuthFailure('Invalid verification code', code: 'invalid-otp');
  
  factory AuthFailure.otpExpired() =>
      AuthFailure('Verification code has expired', code: 'otp-expired');
  
  factory AuthFailure.biometricNotAvailable() =>
      AuthFailure('Biometric authentication not available', code: 'biometric-not-available');
  
  factory AuthFailure.biometricNotEnabled() =>
      AuthFailure('Biometric authentication not enabled', code: 'biometric-not-enabled');
  
  factory AuthFailure.sessionExpired() =>
      AuthFailure('Session has expired. Please log in again.', code: 'session-expired');
  
  factory AuthFailure.tooManyRequests() =>
      AuthFailure('Too many attempts. Please try again later.', code: 'too-many-requests');
}