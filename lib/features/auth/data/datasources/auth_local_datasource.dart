import '../models/user_model.dart';
import '../models/auth_token_model.dart';
import '../models/user_credentials_model.dart';

/// Abstract interface for local authentication data source
abstract class AuthLocalDatasource {
  /// Get cached user data
  Future<UserModel?> getCachedUser();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Get stored auth token
  Future<AuthTokenModel?> getAuthToken();

  /// Store auth token securely
  Future<void> storeAuthToken(AuthTokenModel token);

  /// Clear auth token
  Future<void> clearAuthToken();

  /// Get stored user credentials
  Future<UserCredentialsModel?> getUserCredentials();

  /// Store user credentials for biometric login
  Future<void> storeUserCredentials(UserCredentialsModel credentials);

  /// Clear user credentials
  Future<void> clearUserCredentials();

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled();

  /// Enable biometric authentication
  Future<void> enableBiometric(String oderId);

  /// Disable biometric authentication
  Future<void> disableBiometric();

  /// Get last login timestamp
  Future<DateTime?> getLastLoginTime();

  /// Store last login timestamp
  Future<void> storeLastLoginTime(DateTime time);

  /// Check if session is valid (not timed out)
  Future<bool> isSessionValid();

  /// Clear all auth data
  Future<void> clearAll();

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometric();

  /// Check if biometrics is available on device
  Future<bool> isBiometricAvailable();
}
