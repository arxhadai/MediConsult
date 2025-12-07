import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Base class for all login states
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial login state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// State while login is in progress
class LoginLoading extends LoginState {
  final String? message;

  const LoginLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when OTP has been sent
class LoginOtpSent extends LoginState {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;
  final DateTime sentAt;

  const LoginOtpSent({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
    required this.sentAt,
  });

  /// Time remaining until OTP can be resent (60 seconds)
  Duration get resendCooldown {
    final elapsed = DateTime.now().difference(sentAt);
    final remaining = const Duration(seconds: 60) - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get canResend => resendCooldown == Duration.zero;

  @override
  List<Object?> get props => [verificationId, phoneNumber, resendToken, sentAt];
}

/// State when login is successful
class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when password reset email has been sent
class LoginPasswordResetSent extends LoginState {
  final String email;

  const LoginPasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// State when there's a login error
class LoginError extends LoginState {
  final String message;
  final String? code;

  const LoginError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}
