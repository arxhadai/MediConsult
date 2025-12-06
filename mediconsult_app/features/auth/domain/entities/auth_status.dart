import 'package:equatable/equatable.dart';
import 'user.dart';

/// Represents the current authentication status
class AuthStatus extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final User? user;
  final String? errorMessage;
  final bool requiresVerification;
  final bool requiresProfileSetup;
  final bool sessionExpired;

  const AuthStatus({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.requiresVerification = false,
    this.requiresProfileSetup = false,
    this.sessionExpired = false,
  });

  /// Initial unauthenticated status
  factory AuthStatus.unauthenticated() {
    return const AuthStatus(isAuthenticated: false);
  }

  /// Loading status
  factory AuthStatus.loading() {
    return const AuthStatus(isLoading: true);
  }

  /// Authenticated status with user
  factory AuthStatus.authenticated(User user) {
    return AuthStatus(
      isAuthenticated: true,
      user: user,
      requiresVerification: !user.isFullyVerified,
      requiresProfileSetup: !user.hasCompletedProfile,
    );
  }

  /// Error status
  factory AuthStatus.error(String message) {
    return AuthStatus(
      isAuthenticated: false,
      errorMessage: message,
    );
  }

  /// Session expired status
  factory AuthStatus.sessionExpired() {
    return const AuthStatus(
      isAuthenticated: false,
      sessionExpired: true,
    );
  }

  /// Create a copy with updated fields
  AuthStatus copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    User? user,
    String? errorMessage,
    bool? requiresVerification,
    bool? requiresProfileSetup,
    bool? sessionExpired,
  }) {
    return AuthStatus(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      requiresVerification: requiresVerification ?? this.requiresVerification,
      requiresProfileSetup: requiresProfileSetup ?? this.requiresProfileSetup,
      sessionExpired: sessionExpired ?? this.sessionExpired,
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        isLoading,
        user,
        errorMessage,
        requiresVerification,
        requiresProfileSetup,
        sessionExpired,
      ];
}
