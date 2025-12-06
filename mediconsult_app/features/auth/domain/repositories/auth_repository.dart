import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../enums/user_role.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Get currently authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Sign in with phone number (sends OTP)
  Future<Either<Failure, String>> signInWithPhone({
    required String phoneNumber,
  });

  /// Verify OTP and complete phone authentication
  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String otp,
    required UserRole role,
  });

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Register new user with email
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  });

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle({
    required UserRole role,
  });

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  /// Enable biometric authentication
  Future<Either<Failure, void>> enableBiometric();

  /// Disable biometric authentication
  Future<Either<Failure, void>> disableBiometric();

  /// Authenticate using biometrics
  Future<Either<Failure, User>> authenticateWithBiometric();

  /// Check if biometrics is available
  Future<bool> isBiometricAvailable();

  /// Check if biometric is enabled for current user
  Future<bool> isBiometricEnabled();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  });

  /// Verify doctor credentials
  Future<Either<Failure, void>> submitDoctorVerification({
    required String licenseNumber,
    required String specialization,
    required List<String> documentUrls,
  });

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();

  /// Check session validity and refresh if needed
  Future<Either<Failure, bool>> checkAndRefreshSession();
}
