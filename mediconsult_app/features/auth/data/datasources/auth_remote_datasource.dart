import '../models/user_model.dart';
import '../../domain/enums/user_role.dart';

/// Abstract interface for remote authentication data source
abstract class AuthRemoteDatasource {
  /// Get current Firebase user stream
  Stream<String?> get authStateChanges;

  /// Get current user ID
  Future<String?> get currentUserId;

  /// Sign in with phone number (sends OTP)
  Future<String> signInWithPhone(String phoneNumber);

  /// Verify OTP and complete phone authentication
  Future<UserModel> verifyOtp(String verificationId, String otp, UserRole role);

  /// Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password);

  /// Register new user with email
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String displayName,
    UserRole role,
  );

  /// Sign in with Google
  Future<UserModel> signInWithGoogle(UserRole role);

  /// Sign out
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid);

  /// Save user data to Firestore
  Future<void> saveUserData(UserModel user);

  /// Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data);

  /// Submit doctor verification documents
  Future<void> submitDoctorVerification(
    String uid,
    String licenseNumber,
    String specialization,
    List<String> documentUrls,
  );
}
