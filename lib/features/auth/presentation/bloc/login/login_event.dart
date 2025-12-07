import 'package:equatable/equatable.dart';
import '../../../domain/enums/user_role.dart';

/// Base class for all login events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event when phone login is initiated
class LoginPhoneSubmitted extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneSubmitted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event when OTP is submitted
class LoginOtpSubmitted extends LoginEvent {
  final String verificationId;
  final String otp;
  final UserRole role;

  const LoginOtpSubmitted({
    required this.verificationId,
    required this.otp,
    required this.role,
  });

  @override
  List<Object?> get props => [verificationId, otp, role];
}

/// Event when email login is submitted
class LoginEmailSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginEmailSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event when Google login is requested
class LoginGoogleRequested extends LoginEvent {
  final UserRole role;

  const LoginGoogleRequested({required this.role});

  @override
  List<Object?> get props => [role];
}

/// Event when password reset is requested
class LoginPasswordResetRequested extends LoginEvent {
  final String email;

  const LoginPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event to resend OTP
class LoginOtpResendRequested extends LoginEvent {
  final String phoneNumber;

  const LoginOtpResendRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event to clear login error
class LoginErrorCleared extends LoginEvent {
  const LoginErrorCleared();
}
