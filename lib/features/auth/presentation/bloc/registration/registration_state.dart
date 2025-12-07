import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Base class for all registration states
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

/// Initial registration state
class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();
}

/// State while registration is in progress
class RegistrationLoading extends RegistrationState {
  final String? message;

  const RegistrationLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when registration is successful
class RegistrationSuccess extends RegistrationState {
  final User user;
  final bool requiresVerification;

  const RegistrationSuccess({
    required this.user,
    this.requiresVerification = false,
  });

  @override
  List<Object?> get props => [user, requiresVerification];
}

/// State when doctor verification is submitted
class RegistrationVerificationSubmitted extends RegistrationState {
  const RegistrationVerificationSubmitted();
}

/// State when profile is updated
class RegistrationProfileUpdated extends RegistrationState {
  final User user;

  const RegistrationProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State with password strength information
class RegistrationPasswordStrength extends RegistrationState {
  final PasswordStrength strength;
  final List<String> requirements;

  const RegistrationPasswordStrength({
    required this.strength,
    required this.requirements,
  });

  @override
  List<Object?> get props => [strength, requirements];
}

/// State when there's a registration error
class RegistrationError extends RegistrationState {
  final String message;
  final String? code;

  const RegistrationError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Password strength levels
enum PasswordStrength {
  weak,
  fair,
  good,
  strong,
}
