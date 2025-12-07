import 'package:equatable/equatable.dart';
import '../enums/auth_provider_type.dart';

/// Represents user authentication credentials
class AuthCredentials extends Equatable {
  final String userId;
  final AuthProviderType providerType;
  final String? email;
  final String? phoneNumber;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final bool isAuthenticated;

  const AuthCredentials({
    required this.userId,
    required this.providerType,
    this.email,
    this.phoneNumber,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.isAuthenticated = false,
  });

  /// Check if credentials are expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if credentials need refresh
  bool get needsRefresh {
    if (expiresAt == null) return false;
    // Refresh if less than 5 minutes remaining
    return DateTime.now().isAfter(
      expiresAt!.subtract(const Duration(minutes: 5)),
    );
  }

  /// Create a copy with updated fields
  AuthCredentials copyWith({
    String? userId,
    AuthProviderType? providerType,
    String? email,
    String? phoneNumber,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool? isAuthenticated,
  }) {
    return AuthCredentials(
      userId: userId ?? this.userId,
      providerType: providerType ?? this.providerType,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        providerType,
        email,
        phoneNumber,
        accessToken,
        refreshToken,
        expiresAt,
        isAuthenticated,
      ];
}
