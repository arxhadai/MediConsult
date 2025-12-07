import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

import '../models/user_model.dart';
import '../models/auth_token_model.dart';
import '../models/user_credentials_model.dart';
import 'auth_local_datasource.dart';

/// Implementation of AuthLocalDatasource using secure storage
@LazySingleton(as: AuthLocalDatasource)
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  final SharedPreferences _prefs;

  // Storage keys
  static const String _keyUser = 'cached_user';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserCredentials = 'user_credentials';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyBiometricUserId = 'biometric_user_id';
  static const String _keyLastLogin = 'last_login_time';

  // Session timeout in minutes (HIPAA compliance)
  static const int _sessionTimeoutMinutes = 30;

  AuthLocalDatasourceImpl({
    required FlutterSecureStorage secureStorage,
    required LocalAuthentication localAuth,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage,
        _localAuth = localAuth,
        _prefs = prefs;

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = await _secureStorage.read(key: _keyUser);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _secureStorage.write(key: _keyUser, value: jsonString);
  }

  @override
  Future<void> clearCachedUser() async {
    await _secureStorage.delete(key: _keyUser);
  }

  @override
  Future<AuthTokenModel?> getAuthToken() async {
    final jsonString = await _secureStorage.read(key: _keyAuthToken);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthTokenModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> storeAuthToken(AuthTokenModel token) async {
    final jsonString = jsonEncode(token.toJson());
    await _secureStorage.write(key: _keyAuthToken, value: jsonString);
  }

  @override
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: _keyAuthToken);
  }

  @override
  Future<UserCredentialsModel?> getUserCredentials() async {
    final jsonString = await _secureStorage.read(key: _keyUserCredentials);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserCredentialsModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> storeUserCredentials(UserCredentialsModel credentials) async {
    final jsonString = jsonEncode(credentials.toJson());
    await _secureStorage.write(key: _keyUserCredentials, value: jsonString);
  }

  @override
  Future<void> clearUserCredentials() async {
    await _secureStorage.delete(key: _keyUserCredentials);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return _prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  @override
  Future<void> enableBiometric(String userId) async {
    // Check if biometrics is available
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      throw Exception('Biometric authentication not available on this device');
    }

    // Authenticate to confirm
    final didAuthenticate = await _localAuth.authenticate(
      localizedReason: 'Please authenticate to enable biometric login',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (!didAuthenticate) {
      throw Exception('Biometric authentication failed');
    }

    await _prefs.setBool(_keyBiometricEnabled, true);
    await _secureStorage.write(key: _keyBiometricUserId, value: userId);
  }

  @override
  Future<void> disableBiometric() async {
    await _prefs.setBool(_keyBiometricEnabled, false);
    await _secureStorage.delete(key: _keyBiometricUserId);
  }

  @override
  Future<DateTime?> getLastLoginTime() async {
    final timestamp = _prefs.getString(_keyLastLogin);
    if (timestamp == null) return null;

    try {
      return DateTime.parse(timestamp);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> storeLastLoginTime(DateTime time) async {
    await _prefs.setString(_keyLastLogin, time.toIso8601String());
  }

  @override
  Future<bool> isSessionValid() async {
    final lastLogin = await getLastLoginTime();
    if (lastLogin == null) return false;

    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    // Session expires after 30 minutes (HIPAA compliance)
    return difference.inMinutes < _sessionTimeoutMinutes;
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      clearCachedUser(),
      clearAuthToken(),
      clearUserCredentials(),
    ]);
    await _prefs.remove(_keyLastLogin);
    // Don't clear biometric settings - user might want to re-enable
  }

  /// Authenticate with biometrics
  @override
  Future<bool> authenticateWithBiometric() async {
    final isEnabled = await isBiometricEnabled();
    if (!isEnabled) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Check if biometrics is available on device
  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }
}
