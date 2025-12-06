import 'package:equatable/equatable.dart';

/// Model for storing authentication tokens
class AuthTokenModel extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String userId;

  const AuthTokenModel({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    required this.userId,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token needs refresh (less than 5 minutes remaining)
  bool get needsRefresh =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));

  /// Create from JSON
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userId: json['userId'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, userId];
}
