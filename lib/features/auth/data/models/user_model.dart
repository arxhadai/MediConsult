import '../../domain/entities/user.dart';
import '../../domain/enums/user_role.dart';
import '../../domain/enums/verification_status.dart';

/// Data model for User entity with JSON serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    super.email,
    super.phoneNumber,
    super.displayName,
    super.photoUrl,
    required super.role,
    required super.verificationStatus,
    super.isBiometricEnabled,
    required super.createdAt,
    super.lastLoginAt,
    super.licenseNumber,
    super.specialization,
    super.isVerifiedDoctor,
    super.dateOfBirth,
    super.bloodGroup,
    super.allergies,
  });

  /// Create UserModel from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'patient'),
      verificationStatus: VerificationStatus.fromString(
        json['verificationStatus'] as String? ?? 'pending',
      ),
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      licenseNumber: json['licenseNumber'] as String?,
      specialization: json['specialization'] as String?,
      isVerifiedDoctor: json['isVerifiedDoctor'] as bool? ?? false,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      bloodGroup: json['bloodGroup'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.value,
      'verificationStatus': verificationStatus.value,
      'isBiometricEnabled': isBiometricEnabled,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'licenseNumber': licenseNumber,
      'specialization': specialization,
      'isVerifiedDoctor': isVerifiedDoctor,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'allergies': allergies,
    };
  }

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      role: user.role,
      verificationStatus: user.verificationStatus,
      isBiometricEnabled: user.isBiometricEnabled,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      licenseNumber: user.licenseNumber,
      specialization: user.specialization,
      isVerifiedDoctor: user.isVerifiedDoctor,
      dateOfBirth: user.dateOfBirth,
      bloodGroup: user.bloodGroup,
      allergies: user.allergies,
    );
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      displayName: displayName,
      photoUrl: photoUrl,
      role: role,
      verificationStatus: verificationStatus,
      isBiometricEnabled: isBiometricEnabled,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      licenseNumber: licenseNumber,
      specialization: specialization,
      isVerifiedDoctor: isVerifiedDoctor,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      allergies: allergies,
    );
  }

  /// Create copy with updated fields
  @override
  UserModel copyWith({
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
    return UserModel(
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
}
