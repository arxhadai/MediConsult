import 'package:equatable/equatable.dart';
import '../enums/user_role.dart';
import '../enums/verification_status.dart';

/// User entity representing an authenticated user in the system
class User extends Equatable {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final bool isBiometricEnabled;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  // Doctor-specific fields
  final String? licenseNumber;
  final String? specialization;
  final bool isVerifiedDoctor;

  // Patient-specific fields
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final List<String>? allergies;

  const User({
    required this.id,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    required this.role,
    required this.verificationStatus,
    this.isBiometricEnabled = false,
    required this.createdAt,
    this.lastLoginAt,
    this.licenseNumber,
    this.specialization,
    this.isVerifiedDoctor = false,
    this.dateOfBirth,
    this.bloodGroup,
    this.allergies,
  });

  /// Check if user is a doctor
  bool get isDoctor => role == UserRole.doctor;

  /// Check if user is a patient
  bool get isPatient => role == UserRole.patient;

  /// Check if user is an admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is fully verified
  bool get isFullyVerified => verificationStatus == VerificationStatus.verified;

  /// Check if user has completed profile setup
  bool get hasCompletedProfile => displayName != null && displayName!.isNotEmpty;

  /// Get initials for avatar placeholder
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email?.substring(0, 1).toUpperCase() ?? '?';
    }
    final names = displayName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName![0].toUpperCase();
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    VerificationStatus? verificationStatus,
    bool? isBiometricEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? licenseNumber,
    String? specialization,
    bool? isVerifiedDoctor,
    DateTime? dateOfBirth,
    String? bloodGroup,
    List<String>? allergies,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialization: specialization ?? this.specialization,
      isVerifiedDoctor: isVerifiedDoctor ?? this.isVerifiedDoctor,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        displayName,
        photoUrl,
        role,
        verificationStatus,
        isBiometricEnabled,
        createdAt,
        lastLoginAt,
        licenseNumber,
        specialization,
        isVerifiedDoctor,
        dateOfBirth,
        bloodGroup,
        allergies,
      ];
}
