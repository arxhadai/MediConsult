import 'package:equatable/equatable.dart';
import '../../../domain/enums/user_role.dart';

/// Base class for all registration events
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

/// Event when email registration is submitted
class RegistrationEmailSubmitted extends RegistrationEvent {
  final String email;
  final String password;
  final String displayName;
  final UserRole role;

  const RegistrationEmailSubmitted({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, displayName, role];
}

/// Event when doctor verification is submitted
class RegistrationDoctorVerificationSubmitted extends RegistrationEvent {
  final String licenseNumber;
  final String specialization;
  final List<String> documentUrls;

  const RegistrationDoctorVerificationSubmitted({
    required this.licenseNumber,
    required this.specialization,
    required this.documentUrls,
  });

  @override
  List<Object?> get props => [licenseNumber, specialization, documentUrls];
}

/// Event when profile update is submitted
class RegistrationProfileUpdateSubmitted extends RegistrationEvent {
  final String? displayName;
  final String? photoUrl;
  final Map<String, dynamic>? additionalData;

  const RegistrationProfileUpdateSubmitted({
    this.displayName,
    this.photoUrl,
    this.additionalData,
  });

  @override
  List<Object?> get props => [displayName, photoUrl, additionalData];
}

/// Event to clear registration error
class RegistrationErrorCleared extends RegistrationEvent {
  const RegistrationErrorCleared();
}

/// Event to validate password strength
class RegistrationPasswordValidated extends RegistrationEvent {
  final String password;

  const RegistrationPasswordValidated(this.password);

  @override
  List<Object?> get props => [password];
}
