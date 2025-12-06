import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/enums/user_role.dart';
import '../../domain/enums/auth_provider_type.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_local_datasource_impl.dart';
import '../models/user_model.dart';
import '../models/user_credentials_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final AuthLocalDatasourceImpl _localDatasourceImpl;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required AuthLocalDatasourceImpl localDatasourceImpl,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _localDatasourceImpl = localDatasourceImpl;

  @override
  Stream<User?> get authStateChanges {
    return _remoteDatasource.authStateChanges.asyncMap((uid) async {
      if (uid == null) return null;

      try {
        final user = await _remoteDatasource.getUserData(uid);
        if (user != null) {
          await _localDatasource.cacheUser(user);
          await _localDatasource.storeLastLoginTime(DateTime.now());
        }
        return user;
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final uid = await _remoteDatasource.currentUserId;
      if (uid == null) {
        return const Right(null);
      }

      // Check session validity
      final isSessionValid = await _localDatasource.isSessionValid();
      if (!isSessionValid) {
        await signOut();
        return Left(AuthFailure.sessionExpired());
      }

      // Try cached user first
      final cachedUser = await _localDatasource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // Fetch from remote
      final remoteUser = await _remoteDatasource.getUserData(uid);
      if (remoteUser != null) {
        await _localDatasource.cacheUser(remoteUser);
      }

      return Right(remoteUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final uid = await _remoteDatasource.currentUserId;
    if (uid == null) return false;

    final isSessionValid = await _localDatasource.isSessionValid();
    return isSessionValid;
  }

  @override
  Future<Either<Failure, String>> signInWithPhone({
    required String phoneNumber,
  }) async {
    try {
      final verificationId = await _remoteDatasource.signInWithPhone(phoneNumber);
      return Right(verificationId);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String otp,
    required UserRole role,
  }) async {
    try {
      final user = await _remoteDatasource.verifyOtp(verificationId, otp, role);
      await _cacheUserSession(user, AuthProviderType.phone);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDatasource.signInWithEmail(email, password);
      await _cacheUserSession(user, AuthProviderType.email);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      final user = await _remoteDatasource.signUpWithEmail(
        email,
        password,
        displayName,
        role,
      );
      await _cacheUserSession(user, AuthProviderType.email);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle({
    required UserRole role,
  }) async {
    try {
      final user = await _remoteDatasource.signInWithGoogle(role);
      await _cacheUserSession(user, AuthProviderType.google);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDatasource.signOut();
      await _localDatasource.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _remoteDatasource.sendPasswordResetEmail(email);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometric() async {
    try {
      final uid = await _remoteDatasource.currentUserId;
      if (uid == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      await _localDatasource.enableBiometric(uid);

      // Update user data
      await _remoteDatasource.updateUserData(uid, {
        'isBiometricEnabled': true,
      });

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometric() async {
    try {
      final uid = await _remoteDatasource.currentUserId;
      if (uid == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      await _localDatasource.disableBiometric();

      // Update user data
      await _remoteDatasource.updateUserData(uid, {
        'isBiometricEnabled': false,
      });

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> authenticateWithBiometric() async {
    try {
      final isEnabled = await _localDatasource.isBiometricEnabled();
      if (!isEnabled) {
        return Left(AuthFailure.biometricNotEnabled());
      }

      final didAuthenticate = await _localDatasourceImpl.authenticateWithBiometric();
      if (!didAuthenticate) {
        return Left(AuthFailure('Biometric authentication failed'));
      }

      // Get cached user
      final cachedUser = await _localDatasource.getCachedUser();
      if (cachedUser == null) {
        return Left(AuthFailure('No cached user found'));
      }

      // Refresh session
      await _localDatasource.storeLastLoginTime(DateTime.now());

      return Right(cachedUser);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    return _localDatasourceImpl.isBiometricAvailable();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return _localDatasource.isBiometricEnabled();
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final uid = await _remoteDatasource.currentUserId;
      if (uid == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (additionalData != null) updateData.addAll(additionalData);

      await _remoteDatasource.updateUserData(uid, updateData);

      // Fetch updated user
      final updatedUser = await _remoteDatasource.getUserData(uid);
      if (updatedUser != null) {
        await _localDatasource.cacheUser(updatedUser);
      }

      return Right(updatedUser!);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitDoctorVerification({
    required String licenseNumber,
    required String specialization,
    required List<String> documentUrls,
  }) async {
    try {
      final uid = await _remoteDatasource.currentUserId;
      if (uid == null) {
        return Left(AuthFailure('User not authenticated'));
      }

      await _remoteDatasource.submitDoctorVerification(
        uid,
        licenseNumber,
        specialization,
        documentUrls,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    // Firebase handles token refresh automatically
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> checkAndRefreshSession() async {
    try {
      final isValid = await _localDatasource.isSessionValid();
      if (!isValid) {
        return Left(AuthFailure.sessionExpired());
      }

      // Update last login time to extend session
      await _localDatasource.storeLastLoginTime(DateTime.now());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Cache user session data locally
  Future<void> _cacheUserSession(UserModel user, AuthProviderType providerType) async {
    await _localDatasource.cacheUser(user);
    await _localDatasource.storeLastLoginTime(DateTime.now());
    await _localDatasource.storeUserCredentials(
      UserCredentialsModel(
        oderId: user.id,
        providerType: providerType,
        email: user.email,
        phoneNumber: user.phoneNumber,
        lastLoginAt: DateTime.now(),
      ),
    );
  }

  /// Map Firebase auth errors to AuthFailure
  AuthFailure _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure.invalidCredentials();
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'invalid-verification-code':
        return AuthFailure.invalidOtp();
      case 'session-expired':
        return AuthFailure.otpExpired();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      default:
        return AuthFailure(e.message ?? 'Authentication error occurred');
    }
  }
}
