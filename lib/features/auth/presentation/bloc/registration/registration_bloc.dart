import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/enums/user_role.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'registration_event.dart';
import 'registration_state.dart';

/// BLoC for handling registration flow
@Injectable()
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository;

  RegistrationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const RegistrationInitial()) {
    on<RegistrationEmailSubmitted>(_onEmailSubmitted);
    on<RegistrationDoctorVerificationSubmitted>(_onDoctorVerificationSubmitted);
    on<RegistrationProfileUpdateSubmitted>(_onProfileUpdateSubmitted);
    on<RegistrationPasswordValidated>(_onPasswordValidated);
    on<RegistrationErrorCleared>(_onErrorCleared);
  }

  Future<void> _onEmailSubmitted(
    RegistrationEmailSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationLoading(message: 'Creating your account...'));

    final result = await _authRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
      role: event.role,
    );

    result.fold(
      (failure) => emit(RegistrationError(message: failure.toString())),
      (user) => emit(RegistrationSuccess(
        user: user,
        requiresVerification: event.role == UserRole.doctor,
      )),
    );
  }

  Future<void> _onDoctorVerificationSubmitted(
    RegistrationDoctorVerificationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationLoading(message: 'Submitting verification...'));

    final result = await _authRepository.submitDoctorVerification(
      licenseNumber: event.licenseNumber,
      specialization: event.specialization,
      documentUrls: event.documentUrls,
    );

    result.fold(
      (failure) => emit(RegistrationError(message: failure.toString())),
      (_) => emit(const RegistrationVerificationSubmitted()),
    );
  }

  Future<void> _onProfileUpdateSubmitted(
    RegistrationProfileUpdateSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(const RegistrationLoading(message: 'Updating profile...'));

    final result = await _authRepository.updateProfile(
      displayName: event.displayName,
      photoUrl: event.photoUrl,
      additionalData: event.additionalData,
    );

    result.fold(
      (failure) => emit(RegistrationError(message: failure.toString())),
      (user) => emit(RegistrationProfileUpdated(user)),
    );
  }

  void _onPasswordValidated(
    RegistrationPasswordValidated event,
    Emitter<RegistrationState> emit,
  ) {
    final password = event.password;
    final requirements = <String>[];
    int score = 0;

    // Check length
    if (password.length >= 8) {
      score++;
    } else {
      requirements.add('At least 8 characters');
    }

    // Check uppercase
    if (password.contains(RegExp(r'[A-Z]'))) {
      score++;
    } else {
      requirements.add('One uppercase letter');
    }

    // Check lowercase
    if (password.contains(RegExp(r'[a-z]'))) {
      score++;
    } else {
      requirements.add('One lowercase letter');
    }

    // Check numbers
    if (password.contains(RegExp(r'[0-9]'))) {
      score++;
    } else {
      requirements.add('One number');
    }

    // Check special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    } else {
      requirements.add('One special character');
    }

    PasswordStrength strength;
    switch (score) {
      case 0:
      case 1:
      case 2:
        strength = PasswordStrength.weak;
        break;
      case 3:
        strength = PasswordStrength.fair;
        break;
      case 4:
        strength = PasswordStrength.good;
        break;
      default:
        strength = PasswordStrength.strong;
    }

    emit(RegistrationPasswordStrength(
      strength: strength,
      requirements: requirements,
    ));
  }

  void _onErrorCleared(
    RegistrationErrorCleared event,
    Emitter<RegistrationState> emit,
  ) {
    emit(const RegistrationInitial());
  }
}
