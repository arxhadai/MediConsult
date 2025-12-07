import 'package:equatable/equatable.dart';
import '../../domain/enums/auth_provider_type.dart';

/// Model for storing user credentials locally
class UserCredentialsModel extends Equatable {
  final String oderId;
  final AuthProviderType providerType;
  final String? email;
  final String? phoneNumber;
  final bool biometricEnabled;
  final DateTime? lastLoginAt;

  const UserCredentialsModel({
    required this.oderId,
    required this.providerType,
    this.email,
    this.phoneNumber,
    this.biometricEnabled = false,
    this.lastLoginAt,
  });

  /// Create from JSON
  factory UserCredentialsModel.fromJson(Map<String, dynamic> json) {
    return UserCredentialsModel(
      oderId: json['userId'] as String,
      providerType: AuthProviderType.fromString(
        json['providerType'] as String? ?? 'email',
      ),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': oderId,
      'providerType': providerType.value,
      'email': email,
      'phoneNumber': phoneNumber,
      'biometricEnabled': biometricEnabled,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  UserCredentialsModel copyWith({
    String? userId,
    AuthProviderType? providerType,
    String? email,
    String? phoneNumber,
    bool? biometricEnabled,
    DateTime? lastLoginAt,
  }) {
    return UserCredentialsModel(
      oderId: userId ?? oderId,
      providerType: providerType ?? this.providerType,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        oderId,
        providerType,
        email,
        phoneNumber,
        biometricEnabled,
        lastLoginAt,
      ];
}
