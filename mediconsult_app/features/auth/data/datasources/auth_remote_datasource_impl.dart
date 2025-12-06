import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../../domain/enums/user_role.dart';
import '../../domain/enums/verification_status.dart';
import 'auth_remote_datasource.dart';

/// Implementation of AuthRemoteDatasource using Firebase
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<String?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((user) => user?.uid);

  @override
  Future<String?> get currentUserId async => _firebaseAuth.currentUser?.uid;

  @override
  Future<String> signInWithPhone(String phoneNumber) async {
    final completer = Completer<String>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
        // Auto-verification on Android
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  @override
  Future<UserModel> verifyOtp(
    String verificationId,
    String otp,
    UserRole role,
  ) async {
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;

    // Check if user exists in Firestore
    UserModel? existingUser = await getUserData(firebaseUser.uid);

    if (existingUser != null) {
      // Update last login
      await updateUserData(firebaseUser.uid, {
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      return existingUser.copyWith(lastLoginAt: DateTime.now());
    }

    // Create new user
    final newUser = UserModel(
      id: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      role: role,
      verificationStatus: VerificationStatus.pending,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await saveUserData(newUser);
    return newUser;
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user!;
    final userData = await getUserData(firebaseUser.uid);

    if (userData == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'User data not found',
      );
    }

    // Update last login
    await updateUserData(firebaseUser.uid, {
      'lastLoginAt': FieldValue.serverTimestamp(),
    });

    return userData.copyWith(lastLoginAt: DateTime.now());
  }

  @override
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String displayName,
    UserRole role,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user!;

    // Update display name
    await firebaseUser.updateDisplayName(displayName);

    final newUser = UserModel(
      id: firebaseUser.uid,
      email: email,
      displayName: displayName,
      role: role,
      verificationStatus: role == UserRole.doctor
          ? VerificationStatus.pending
          : VerificationStatus.verified,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await saveUserData(newUser);
    return newUser;
  }

  @override
  Future<UserModel> signInWithGoogle(UserRole role) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'cancelled',
        message: 'Google sign in was cancelled',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;

    // Check if user exists
    UserModel? existingUser = await getUserData(firebaseUser.uid);

    if (existingUser != null) {
      await updateUserData(firebaseUser.uid, {
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      return existingUser.copyWith(lastLoginAt: DateTime.now());
    }

    // Create new user
    final newUser = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      role: role,
      verificationStatus: role == UserRole.doctor
          ? VerificationStatus.pending
          : VerificationStatus.verified,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await saveUserData(newUser);
    return newUser;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromJson({
      'id': uid,
      ...doc.data()!,
    });
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    final data = user.toJson();
    data.remove('id'); // Don't store ID in document
    data['createdAt'] = FieldValue.serverTimestamp();
    data['lastLoginAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('users').doc(user.id).set(data);
  }

  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  @override
  Future<void> submitDoctorVerification(
    String uid,
    String licenseNumber,
    String specialization,
    List<String> documentUrls,
  ) async {
    await _firestore.collection('users').doc(uid).update({
      'licenseNumber': licenseNumber,
      'specialization': specialization,
      'verificationDocuments': documentUrls,
      'verificationStatus': VerificationStatus.inReview.value,
      'verificationSubmittedAt': FieldValue.serverTimestamp(),
    });

    // Also create a verification request document for admin review
    await _firestore.collection('verification_requests').add({
      'userId': uid,
      'licenseNumber': licenseNumber,
      'specialization': specialization,
      'documentUrls': documentUrls,
      'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}
